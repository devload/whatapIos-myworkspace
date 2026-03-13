import Foundation
import UIKit
import WhatapSessionSnapshot

public enum RecorderState {
    case idle
    case recording
    case paused
}

public protocol SessionRecorderDelegate: AnyObject {
    func recorder(_ recorder: SessionRecorder, didCaptureSnapshot snapshot: FullSnapshot)
    func recorder(_ recorder: SessionRecorder, didSendEvents count: Int)
    func recorder(_ recorder: SessionRecorder, didFailWithError error: Error)
}

public class SessionRecorder {
    public static let shared = SessionRecorder()

    private var state: RecorderState = .idle
    private let sessionId: String
    private let queue: EventQueue
    private let networkClient: NetworkClient
    private let captureInterval: TimeInterval
    private let sendInterval: TimeInterval

    private var captureTimer: Timer?
    private var sendTimer: Timer?
    private weak var window: UIWindow?

    public weak var delegate: SessionRecorderDelegate?

    public var isEnabled: Bool {
        return state == .recording
    }

    private init(
        sessionId: String = UUID().uuidString,
        serverURL: String = "http://localhost:3000",
        captureInterval: TimeInterval = 1.0,
        sendInterval: TimeInterval = 5.0
    ) {
        self.sessionId = sessionId
        self.queue = EventQueue()
        self.captureInterval = captureInterval
        self.sendInterval = sendInterval

        do {
            self.networkClient = try NetworkClient(serverURL: serverURL)
        } catch {
            fatalError("Failed to initialize network client: \(error)")
        }
    }

    public func configure(serverURL: String, captureInterval: TimeInterval = 1.0, sendInterval: TimeInterval = 5.0) throws {
        let _ = try NetworkClient(serverURL: serverURL)
    }

    public func startRecording(in window: UIWindow) {
        guard state != .recording else { return }

        self.window = window
        state = .recording

        captureTimer = Timer.scheduledTimer(withTimeInterval: captureInterval, repeats: true) { [weak self] _ in
            self?.captureSnapshot()
        }

        sendTimer = Timer.scheduledTimer(withTimeInterval: sendInterval, repeats: true) { [weak self] _ in
            self?.sendEvents()
        }

        captureSnapshot()
    }

    public func stopRecording() {
        guard state == .recording else { return }

        captureTimer?.invalidate()
        captureTimer = nil

        sendTimer?.invalidate()
        sendTimer = nil

        sendEvents()

        state = .idle
        window = nil
    }

    public func pauseRecording() {
        guard state == .recording else { return }
        state = .paused

        captureTimer?.invalidate()
        captureTimer = nil
    }

    public func resumeRecording() {
        guard state == .paused else { return }
        state = .recording

        captureTimer = Timer.scheduledTimer(withTimeInterval: captureInterval, repeats: true) { [weak self] _ in
            self?.captureSnapshot()
        }
    }

    private func captureSnapshot() {
        guard let window = window else { return }

        let snapshot = ViewCapture.shared.captureWindow(window)
        queue.addFullSnapshot(snapshot)
        delegate?.recorder(self, didCaptureSnapshot: snapshot)
    }

    private func sendEvents() {
        let events = queue.flush()

        guard !events.isEmpty else { return }

        networkClient.sendEvents(sessionId: sessionId, events: events) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.recorder(self ?? SessionRecorder.shared, didSendEvents: events.count)
            case .failure(let error):
                self?.delegate?.recorder(self ?? SessionRecorder.shared, didFailWithError: error)
            }
        }
    }

    public func flush() {
        sendEvents()
    }
}

import Foundation
import WhatapSessionSnapshot

public protocol EventEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: EventEncoder {}

public class EventQueue {
    private var events: [EventPayload] = []
    private let lock = NSLock()
    private let maxQueueSize: Int
    private let encoder: EventEncoder

    public init(maxQueueSize: Int = 100, encoder: EventEncoder = JSONEncoder()) {
        self.maxQueueSize = maxQueueSize
        self.encoder = encoder
    }

    public func addEvent(_ event: EventPayload) {
        lock.lock()
        defer { lock.unlock() }

        if events.count >= maxQueueSize {
            events.removeFirst()
        }

        events.append(event)
    }

    public func addFullSnapshot(_ snapshot: FullSnapshot) {
        let event = EventPayload(
            type: "full_snapshot",
            timestamp: snapshot.timestamp,
            snapshot: snapshot
        )

        addEvent(event)
    }

    public func flush() -> [EventPayload] {
        lock.lock()
        defer { lock.unlock() }

        let eventsToSend = events
        events.removeAll()
        return eventsToSend
    }

    public var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return events.count
    }
}

import Foundation
import CoreFoundation
import WhatapSessionSnapshot

public struct SessionEvent: Codable {
    public let type: String
    public let timestamp: Int64
    public let data: CodableValue?

    public init(type: String, timestamp: Int64, data: CodableValue? = nil) {
        self.type = type
        self.timestamp = timestamp
        self.data = data
    }
}

public struct CodableValue: Codable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let dict = try? container.decode([String: CodableValue].self) {
            value = dict.mapValues { $0.value }
        } else if let array = try? container.decode([CodableValue].self) {
            value = array.map { $0.value }
        } else {
            value = NSNull()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        if let string = value as? String {
            try container.encode(string)
        } else if let int = value as? Int {
            try container.encode(int)
        } else if let double = value as? Double {
            try container.encode(double)
        } else if let float = value as? Float {
            try container.encode(float)
        } else if let bool = value as? Bool {
            try container.encode(bool)
        } else if let dict = value as? [String: Any] {
            try container.encode(dict.mapValues { CodableValue($0) })
        } else if let array = value as? [Any] {
            try container.encode(array.map { CodableValue($0) })
        } else {
            try container.encodeNil()
        }
    }
}

public struct EventBatch: Codable {
    public let sessionId: String
    public let events: [EventPayload]

    public init(sessionId: String, events: [EventPayload]) {
        self.sessionId = sessionId
        self.events = events
    }
}

public struct EventPayload: Codable {
    public let type: String
    public let timestamp: Int64
    public let data: SnapshotData?

    public init(type: String, timestamp: Int64, data: [String: AnyCodable]? = nil) {
        self.type = type
        self.timestamp = timestamp
        self.data = data.map { SnapshotData(dictionary: $0) }
    }

    public init(type: String, timestamp: Int64, snapshot: FullSnapshot) {
        self.type = type
        self.timestamp = timestamp
        self.data = SnapshotData(snapshot: snapshot)
    }
}

public struct SnapshotData: Codable {
    public let timestamp: Int64?
    public let screenWidth: Double?
    public let screenHeight: Double?
    public let scale: Double?
    public let root: ViewData?

    public init(dictionary: [String: AnyCodable]) {
        self.timestamp = dictionary["timestamp"]?.value as? Int64
        self.screenWidth = dictionary["screenWidth"]?.value as? Double
        self.screenHeight = dictionary["screenHeight"]?.value as? Double
        self.scale = dictionary["scale"]?.value as? Double
        self.root = nil
    }

    public init(snapshot: FullSnapshot) {
        self.timestamp = snapshot.timestamp
        self.screenWidth = snapshot.screenWidth
        self.screenHeight = snapshot.screenHeight
        self.scale = snapshot.scale
        self.root = snapshot.root
    }
}

public struct AnyCodable: Codable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case is NSNull:
            try container.encodeNil()
        case let number as NSNumber:
            // Handle NSNumber from JSONSerialization
            // Check if it's a boolean by comparing with CFBoolean constants
            let isBool = (number as CFBoolean) != nil ||
                         CFEqual(number, kCFBooleanTrue) ||
                         CFEqual(number, kCFBooleanFalse)
            if isBool {
                try container.encode(number.boolValue)
            } else {
                // Use double for all numeric values to preserve precision
                try container.encode(number.doubleValue)
            }
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let float as Float:
            try container.encode(float)
        case let cgFloat as CGFloat:
            try container.encode(Double(cgFloat))
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unable to encode value"))
        }
    }
}

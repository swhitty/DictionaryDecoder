//
//  Copyright © 2018 Simon Whitty. All rights reserved.
//

import Foundation

public final class DictionaryEncoder {

    public init () { }

    public func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        guard let dictionary = try Encoder().encodeToAny(value) as? [String: Any] else {
            throw Error.unsupported
        }

        return dictionary
    }
}

private extension DictionaryEncoder {

    enum Storage {
        case value(Any)
        case container(EncoderContainer)

        func toAny() throws -> Any {
            switch self {
            case .value(let value):
                return value
            case .container(let container):
                return try container.toAny()
            }
        }
    }

    enum Error: Swift.Error {
        case unsupported
        case incomplete(at: [CodingKey])
    }

    final class Encoder: Swift.Encoder, EncoderContainer {
        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey : Any] = [:]

        init(codingPath: [CodingKey] = []) {
            self.codingPath = codingPath
        }

        private(set) var container: EncoderContainer? {
            didSet {
                precondition(oldValue == nil)
            }
        }

        func toAny() throws -> Any {
            guard let container = self.container else {
                throw Error.incomplete(at: self.codingPath)
            }

            return try container.toAny()
        }

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
            let keyed = KeyedContainer<Key>(codingPath: self.codingPath)
            self.container = keyed
            return KeyedEncodingContainer(keyed)
        }

        func unkeyedContainer() -> UnkeyedEncodingContainer {
            let unkeyed = UnkeyedContainer(codingPath: self.codingPath)
            self.container = unkeyed
            return unkeyed
        }

        func singleValueContainer() -> SingleValueEncodingContainer {
            let single = SingleContainer(codingPath: self.codingPath)
            self.container = single
            return single
        }

        func encodeToAny<T>(_ value: T) throws -> Any where T : Encodable {
            try value.encode(to: self)
            return try self.toAny()
        }
    }
}

private protocol EncoderContainer {
    func toAny() throws -> Any
}

extension DictionaryEncoder {

    final class KeyedContainer<K : CodingKey>: KeyedEncodingContainerProtocol, EncoderContainer {

        typealias Key = K
        public let codingPath: [CodingKey]

        private var storage: [String: Storage]

        func toAny() throws -> Any {
            return try self.storage.mapValues { try $0.toAny() }
        }

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
            self.storage = [:]
        }

        func encodeNil(forKey key: Key) throws {
            self.storage[key.stringValue] = .value(Optional<Any>.none as Any)
        }

        func encode(_ value: Bool, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int8, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int16, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int32, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int64, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt8, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt16, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt32, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt64, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: String, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Float, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Double, forKey key: Key) throws {
            self.storage[key.stringValue] = .value(value)
        }

        func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
            let path = self.codingPath.appending(key: key)
            let result = try Encoder(codingPath: path).encodeToAny(value)
            self.storage[key.stringValue] = .value(result)
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
            let path = self.codingPath.appending(key: key)
            let keyed = KeyedContainer<NestedKey>(codingPath: path)
            self.storage[key.stringValue] = .container(keyed)
            return KeyedEncodingContainer(keyed)
        }

        func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
            let path = self.codingPath.appending(key: key)
            let unkeyed = UnkeyedContainer(codingPath: path)
            self.storage[key.stringValue] = .container(unkeyed)
            return unkeyed
        }

        func superEncoder() -> Swift.Encoder {
            return self.superEncoder(forKey: Key(stringValue: "super")!)
        }

        func superEncoder(forKey key: Key) -> Swift.Encoder {
            let path = self.codingPath.appending(key: key)
            let encoder = Encoder(codingPath: path)
            self.storage[key.stringValue] = .container(encoder)
            return encoder
        }
    }

    final class UnkeyedContainer : Swift.UnkeyedEncodingContainer, EncoderContainer {

        func toAny() throws -> Any {
            return try self.storage.map { try $0.toAny() }
        }

        // MARK: Properties
        public let codingPath: [CodingKey]

        private var storage: [Storage] = []

        /// The number of elements encoded into the container.
        public var count: Int {
            return storage.count
        }

        // MARK: - Initialization
        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        // MARK: - UnkeyedEncodingContainer Methods

        func encodeNil() throws {
            self.storage.append(.value(Optional<Any>.none as Any))
        }

        func encode(_ value: Bool) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Int) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Int8) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Int16) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Int32) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Int64) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: UInt) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: UInt8) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: UInt16) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: UInt32) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: UInt64) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: String) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Float) throws {
            self.storage.append(.value(value))
        }

        func encode(_ value: Double) throws {
            self.storage.append(.value(value))
        }

        func encode<T : Encodable>(_ value: T) throws {
            let path = self.codingPath.appending(index: self.count)
            let result = try Encoder(codingPath: path).encodeToAny(value)
            self.storage.append(.value(result))
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
            let path = self.codingPath.appending(index: self.count)
            let keyed = KeyedContainer<NestedKey>(codingPath: path)
            self.storage.append(.container(keyed))
            return KeyedEncodingContainer(keyed)
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let path = self.codingPath.appending(index: self.count)
            let unkeyed = UnkeyedContainer(codingPath: path)
            self.storage.append(.container(unkeyed))
            return unkeyed
        }

        func superEncoder() -> Swift.Encoder {
            let path = self.codingPath.appending(index: self.count)
            let encoder = Encoder(codingPath: path)
            self.storage.append(.container(encoder))
            return encoder
        }
    }

    final class SingleContainer: SingleValueEncodingContainer, EncoderContainer {

        func toAny() throws -> Any {
            guard let value = self.value else {
                throw Error.incomplete(at: self.codingPath)
            }
            return value
        }

        var value: Any?

        // MARK: Properties
        public let codingPath: [CodingKey]

        // MARK: - Initialization
        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        func encodeNil() throws {
            self.value = .some(Optional<Any>.none as Any)
        }

        func encode(_ value: Bool) throws {
            self.value = value
        }

        func encode(_ value: String) throws {
            self.value = value
        }

        func encode(_ value: Double) throws {
            self.value = value
        }

        func encode(_ value: Float) throws {
            self.value = value
        }

        func encode(_ value: Int) throws {
            self.value = value
        }

        func encode(_ value: Int8) throws {
            self.value = value
        }

        func encode(_ value: Int16) throws {
            self.value = value
        }

        func encode(_ value: Int32) throws {
            self.value = value
        }

        func encode(_ value: Int64) throws {
            self.value = value
        }

        func encode(_ value: UInt) throws {
            self.value = value
        }

        func encode(_ value: UInt8) throws {
            self.value = value
        }

        func encode(_ value: UInt16) throws {
            self.value = value
        }

        func encode(_ value: UInt32) throws {
            self.value = value
        }

        func encode(_ value: UInt64) throws {
            self.value = value
        }

        func encode<T>(_ value: T) throws where T : Encodable {
            let encoder = Encoder(codingPath: self.codingPath)
            self.value = try encoder.encodeToAny(value)
        }
    }
}

extension Array where Element == CodingKey {

    func appending(key codingKey: CodingKey) -> [CodingKey] {
        var path = self
        path.append(codingKey)
        return path
    }

    func appending(index: Int) -> [CodingKey] {
        var path = self
        path.append(IndexKey(intValue: index))
        return path
    }

    struct IndexKey: CodingKey {
        var intValue: Int? {
            return self.index
        }

        var stringValue: String {
            return "Index \(self.index)"
        }

        var index: Int

        init(intValue index: Int) {
            self.index = index
        }

        init?(stringValue: String) {
            return nil
        }
    }
}

//
//  DictionaryEncoder.swift
//  DictionaryDecoder
//
//  Created by Simon Whitty on 22/10/2018.
//  Copyright 2019 Simon Whitty
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/swhitty/DictionaryDecoder
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
                throw Error.incomplete(at: codingPath)
            }

            return try container.toAny()
        }

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
            let keyed = KeyedContainer<Key>(codingPath: codingPath)
            container = keyed
            return KeyedEncodingContainer(keyed)
        }

        func unkeyedContainer() -> UnkeyedEncodingContainer {
            let unkeyed = UnkeyedContainer(codingPath: codingPath)
            container = unkeyed
            return unkeyed
        }

        func singleValueContainer() -> SingleValueEncodingContainer {
            let single = SingleContainer(codingPath: codingPath)
            container = single
            return single
        }

        func encodeToAny<T>(_ value: T) throws -> Any where T : Encodable {
            try value.encode(to: self)
            return try toAny()
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

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
            self.storage = [:]
        }

        private var storage: [String: Storage]

        func toAny() throws -> Any {
            return try storage.mapValues { try $0.toAny() }
        }

        func encodeNil(forKey key: Key) throws {
            storage[key.stringValue] = .value(Optional<Any>.none as Any)
        }

        func encode(_ value: Bool, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int8, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int16, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int32, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Int64, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt8, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt16, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt32, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: UInt64, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: String, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Float, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode(_ value: Double, forKey key: Key) throws {
            storage[key.stringValue] = .value(value)
        }

        func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
            guard T.self != Date.self else {
                storage[key.stringValue] = .value(value)
                return
            }

            let path = codingPath.appending(key: key)
            let result = try Encoder(codingPath: path).encodeToAny(value)
            storage[key.stringValue] = .value(result)
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
            let path = codingPath.appending(key: key)
            let keyed = KeyedContainer<NestedKey>(codingPath: path)
            storage[key.stringValue] = .container(keyed)
            return KeyedEncodingContainer(keyed)
        }

        func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
            let path = codingPath.appending(key: key)
            let unkeyed = UnkeyedContainer(codingPath: path)
            storage[key.stringValue] = .container(unkeyed)
            return unkeyed
        }

        func superEncoder() -> Swift.Encoder {
            return superEncoder(forKey: Key(stringValue: "super")!)
        }

        func superEncoder(forKey key: Key) -> Swift.Encoder {
            let path = codingPath.appending(key: key)
            let encoder = Encoder(codingPath: path)
            storage[key.stringValue] = .container(encoder)
            return encoder
        }
    }

    final class UnkeyedContainer : Swift.UnkeyedEncodingContainer, EncoderContainer {

        public let codingPath: [CodingKey]

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        private var storage: [Storage] = []

        func toAny() throws -> Any {
            return try storage.map { try $0.toAny() }
        }

        public var count: Int {
            return storage.count
        }

        func encodeNil() throws {
            storage.append(.value(Optional<Any>.none as Any))
        }

        func encode(_ value: Bool) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Int) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Int8) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Int16) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Int32) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Int64) throws {
            storage.append(.value(value))
        }

        func encode(_ value: UInt) throws {
            storage.append(.value(value))
        }

        func encode(_ value: UInt8) throws {
            storage.append(.value(value))
        }

        func encode(_ value: UInt16) throws {
            storage.append(.value(value))
        }

        func encode(_ value: UInt32) throws {
            storage.append(.value(value))
        }

        func encode(_ value: UInt64) throws {
            storage.append(.value(value))
        }

        func encode(_ value: String) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Float) throws {
            storage.append(.value(value))
        }

        func encode(_ value: Double) throws {
            storage.append(.value(value))
        }

        func encode<T : Encodable>(_ value: T) throws {
            guard T.self != Date.self else {
                storage.append(.value(value))
                return
            }

            let path = codingPath.appending(index: count)
            let result = try Encoder(codingPath: path).encodeToAny(value)
            storage.append(.value(result))
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
            let path = codingPath.appending(index: count)
            let keyed = KeyedContainer<NestedKey>(codingPath: path)
            storage.append(.container(keyed))
            return KeyedEncodingContainer(keyed)
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let path = codingPath.appending(index: count)
            let unkeyed = UnkeyedContainer(codingPath: path)
            storage.append(.container(unkeyed))
            return unkeyed
        }

        func superEncoder() -> Swift.Encoder {
            let path = codingPath.appending(index: count)
            let encoder = Encoder(codingPath: path)
            storage.append(.container(encoder))
            return encoder
        }
    }

    final class SingleContainer: SingleValueEncodingContainer, EncoderContainer {

        public let codingPath: [CodingKey]

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        var storage: Any?

        func toAny() throws -> Any {
            guard let value = storage else {
                throw Error.incomplete(at: codingPath)
            }
            return value
        }

        func encodeNil() throws {
            storage = .some(Optional<Any>.none as Any)
        }

        func encode(_ value: Bool) throws {
            storage = value
        }

        func encode(_ value: String) throws {
            storage = value
        }

        func encode(_ value: Double) throws {
            storage = value
        }

        func encode(_ value: Float) throws {
            storage = value
        }

        func encode(_ value: Int) throws {
            storage = value
        }

        func encode(_ value: Int8) throws {
            storage = value
        }

        func encode(_ value: Int16) throws {
            storage = value
        }

        func encode(_ value: Int32) throws {
            storage = value
        }

        func encode(_ value: Int64) throws {
            storage = value
        }

        func encode(_ value: UInt) throws {
            storage = value
        }

        func encode(_ value: UInt8) throws {
            storage = value
        }

        func encode(_ value: UInt16) throws {
            storage = value
        }

        func encode(_ value: UInt32) throws {
            storage = value
        }

        func encode(_ value: UInt64) throws {
            storage = value
        }

        func encode<T>(_ value: T) throws where T : Encodable {
            guard T.self != Date.self else {
                storage = value
                return
            }

            let encoder = Encoder(codingPath: codingPath)
            storage = try encoder.encodeToAny(value)
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
            return index
        }

        var stringValue: String {
            return "Index \(index)"
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

//
//  DictionaryDecoder.swift
//  DictionaryDecoder
//
//  Created by Simon Whitty on 22/10/18.
//  Copyright 2018 Simon Whitty
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/swhitty/DictionaryDecoder
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


import Foundation

public final class DictionaryDecoder {

    public init () { }

    public func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {

        let decoder = Decoder(codingPath: [], storage: .keyed(dictionary))
        return try T.init(from: decoder)
    }
}


private extension DictionaryDecoder {

    enum Error: Swift.Error {
        case missingValue(at: [CodingKey])
        case unexpectedValue(at: [CodingKey])
    }

    struct Decoder: Swift.Decoder {

        var storage: Storage
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey : Any]

        init(codingPath: [CodingKey], storage: Storage) {
            self.codingPath = codingPath
            self.storage = storage
            self.userInfo = [:]
        }

        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            guard case .keyed(let storage) = self.storage  else {
                throw Error.unexpectedValue(at: self.codingPath)
            }

            let keyed = KeyedContainer<Key>(codingPath: self.codingPath,
                                            storage: storage)
            return KeyedDecodingContainer<Key>(keyed)
        }

        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            guard case .unkeyed(let storage) = self.storage  else {
                throw Error.unexpectedValue(at: self.codingPath)
            }

            return UnkeyedContainer(codingPath: self.codingPath, storage: storage)
        }

        func singleValueContainer() throws -> SingleValueDecodingContainer {
            guard case .single(let value) = self.storage  else {
                throw Error.unexpectedValue(at: self.codingPath)
            }

            return SingleContainer(value: value, codingPath: [])
        }

        enum Storage {
            case keyed([String: Any])
            case unkeyed([Any])
            case single(Any)
        }
    }

    // To assist in representing Optional<Any> because `Any` always casts to Optional<Any>
    enum AnyOptional {
        case none
        case some(Any)

        init?(_ any: Any) {
            guard Mirror(reflecting: any).displayStyle == .optional else {
                return nil
            }

            if case Optional<Any>.some(let wrapped) = any {
                self = .some(wrapped)
            } else {
                self = .none
            }
        }

        var isNone: Bool {
            switch self {
            case .none:
                return true
            case .some(_):
                return false
            }
        }
    }
}

extension DictionaryDecoder {

    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {

        let storage: [String: Any]
        var codingPath: [CodingKey]

        init(codingPath: [CodingKey], storage: [String: Any]) {
            self.codingPath = codingPath
            self.storage = storage
        }

        var allKeys: [Key] {
            return self.storage.keys.compactMap {
                Key(stringValue: $0)
            }
        }

        func getValue<T>(for key: Key) throws -> T {
            guard let value = storage[key.stringValue] as? T else {
                let path = self.codingPath.appending(key: key)
                throw Error.unexpectedValue(at: path)
            }
            return value
        }

        private func getStorage(for key: Key) throws -> Decoder.Storage {
            guard let value = storage[key.stringValue] else {
                let path = self.codingPath.appending(key: key)
                throw Error.missingValue(at: path)
            }

            if let keyedValue = value as? [String: Any] {
                return .keyed(keyedValue)
            } else if let unkeyedValue = value as? [Any] {
                return .unkeyed(unkeyedValue)
            }
            return .single(value)
        }

        func contains(_ key: Key) -> Bool {
            return storage[key.stringValue] != nil
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            let path = self.codingPath.appending(key: key)
            guard
                let value = storage[key.stringValue] else {
                throw Error.missingValue(at: path)
            }

            guard let optional = AnyOptional(value) else {
                throw Error.unexpectedValue(at: path)
            }

            return optional.isNone
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            return try getValue(for: key)
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            return try getValue(for: key)
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            return try getValue(for: key)
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            return try getValue(for: key)
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            return try getValue(for: key)
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            return try getValue(for: key)
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            return try getValue(for: key)
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            return try getValue(for: key)
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            return try getValue(for: key)
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            return try getValue(for: key)
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            return try getValue(for: key)
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            return try getValue(for: key)
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            return try getValue(for: key)
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            return try getValue(for: key)
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            let storage = try getStorage(for: key)
            let decoder = DictionaryDecoder.Decoder(codingPath: [],
                                                    storage: storage)
            return try T.init(from: decoder)
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let path = self.codingPath.appending(key: key)
            let storage = try getValue(for: key) as [String: Any]
            let keyed = KeyedContainer<NestedKey>(codingPath: path,
                                                  storage: storage)
            return KeyedDecodingContainer<NestedKey>(keyed)
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            let path = self.codingPath.appending(key: key)
            let storage = try getValue(for: key) as [Any]
            return UnkeyedContainer(codingPath: path, storage: storage)
        }

        func superDecoder() throws -> Swift.Decoder {
            return DictionaryDecoder.Decoder(codingPath: self.codingPath,
                                             storage: .keyed(self.storage))
        }

        func superDecoder(forKey key: Key) throws -> Swift.Decoder {
            let storage = try getStorage(for: key)
            return DictionaryDecoder.Decoder(codingPath: self.codingPath,
                                             storage: storage)
        }
    }

    struct UnkeyedContainer: UnkeyedDecodingContainer {

        private(set) var storage: [Any]

        private(set) var codingPath: [CodingKey]

        init(codingPath: [CodingKey], storage: [Any]) {
            self.codingPath = codingPath
            self.storage = storage
        }

        var count: Int? {
            return self.storage.count
        }

        var isAtEnd: Bool {
            return self.currentIndex == self.storage.count
        }

        private(set) var currentIndex: Int = 0

        mutating func getValue<T>() throws -> T {
            guard
                self.isAtEnd == false,
                let value = self.storage[currentIndex] as? T else {
                    let path = self.codingPath.appending(index: self.currentIndex)
                    throw Error.unexpectedValue(at: path)
            }

            currentIndex += 1
            return value
        }

        private mutating func getStorage() throws -> Decoder.Storage {
            let value = try self.getValue() as Any

            if let keyedValue = value as? [String: Any] {
                return .keyed(keyedValue)
            } else if let unkeyedValue = value as? [Any] {
                return .unkeyed(unkeyedValue)
            }
            return .single(value)
        }

        mutating func decodeNil() throws -> Bool {
            let value = try self.getValue() as Any

            guard let optional = AnyOptional(value) else {
                let path = self.codingPath.appending(index: self.currentIndex)
                throw Error.unexpectedValue(at: path)
            }

            return optional.isNone
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            return try self.getValue()
        }

        mutating func decode(_ type: String.Type) throws -> String {
            return try self.getValue()
        }

        mutating func decode(_ type: Double.Type) throws -> Double {
            return try self.getValue()
        }

        mutating func decode(_ type: Float.Type) throws -> Float {
            return try self.getValue()
        }

        mutating func decode(_ type: Int.Type) throws -> Int {
            return try self.getValue()
        }

        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return try self.getValue()
        }

        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return try self.getValue()
        }

        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return try self.getValue()
        }

        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return try self.getValue()
        }

        mutating func decode(_ type: UInt.Type) throws -> UInt {
            return try self.getValue()
        }

        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try self.getValue()
        }

        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try self.getValue()
        }

        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try self.getValue()
        }

        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try self.getValue()
        }

        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let path = self.codingPath.appending(index: self.currentIndex)
            let storage = try self.getStorage()
            let decoder = DictionaryDecoder.Decoder(codingPath: path,
                                                    storage: storage)

            return try T.init(from: decoder)
        }

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let path = self.codingPath.appending(index: self.currentIndex)
            let storage = try self.getStorage()
            let decoder = DictionaryDecoder.Decoder(codingPath: path,
                                                    storage: storage)
            return try decoder.container(keyedBy: type)
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let path = self.codingPath.appending(index: self.currentIndex)
            let storage = try self.getStorage()
            let decoder = DictionaryDecoder.Decoder(codingPath: path,
                                                    storage: storage)
            return try decoder.unkeyedContainer()
        }

        mutating func superDecoder() throws -> Swift.Decoder {
            let path = self.codingPath.appending(index: self.currentIndex)
            let storage = try self.getStorage()
            return DictionaryDecoder.Decoder(codingPath: path,
                                             storage: storage)
        }
    }

    struct SingleContainer: SingleValueDecodingContainer {

        private(set) var codingPath: [CodingKey]

        private var value: Any

        init(value: Any, codingPath: [CodingKey]) {
            self.value = value
            self.codingPath = codingPath
        }

        func decodeNil() -> Bool {
            let optional = AnyOptional(self.value)
            return optional?.isNone == true
        }

        func getValue<T>() throws -> T {
            guard let value = self.value as? T else {
                throw Error.unexpectedValue(at: self.codingPath)
            }
            return value
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            return try self.getValue()
        }

        func decode(_ type: String.Type) throws -> String {
            return try self.getValue()
        }

        func decode(_ type: Double.Type) throws -> Double {
            return try self.getValue()
        }

        func decode(_ type: Float.Type) throws -> Float {
             return try self.getValue()
        }

        func decode(_ type: Int.Type) throws -> Int {
            return try self.getValue()
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            return try self.getValue()
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            return try self.getValue()
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            return try self.getValue()
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            return try self.getValue()
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            return try self.getValue()
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try self.getValue()
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try self.getValue()
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
             return try self.getValue()
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try self.getValue()
        }

        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let decoder = DictionaryDecoder.Decoder(codingPath: self.codingPath,
                                                    storage: .single(self.value))

            return try T.init(from: decoder)
        }
    }
}

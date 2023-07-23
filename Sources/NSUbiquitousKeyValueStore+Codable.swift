//
//  NSUbiquitousKeyValueStore+Codable.swift
//  DictionaryDecoder
//
//  Created by Simon Whitty on 21/20/2019.
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

@available(watchOS 9.0, *)
public extension NSUbiquitousKeyValueStore {

    func encode<T: Encodable>(_ value: T, forKey key: String) throws {
        let encoded = try KeyValueEncoder().encode(value)
        if KeyValueDecoder.isValueNil(encoded) {
            removeObject(forKey: key)
        } else {
            set(encoded, forKey: key)
        }
    }

    func decode<T: Decodable>(_ type: T?.Type, forKey key: String) throws -> T? {
        guard let storage = object(forKey: key) else { return nil }
        return try KeyValueDecoder().decode(type, from: storage)
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T {
        try KeyValueDecoder().decode(type, from: object(forKey: key) as Any)
    }
}

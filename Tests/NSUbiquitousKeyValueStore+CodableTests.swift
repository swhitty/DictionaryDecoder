//
//  NSUbiquitousKeyValueStore+CodableTests.swift
//  DictionaryDecoder
//
//  Created by Simon Whitty on 26/11/2018.
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

@testable import DictionaryDecoder

import Foundation
import XCTest

final class NSUbiquitousKeyValueStoreCodableTests: XCTestCase {

    func testThrowsWhenKeyMissing() throws {
        let defaults = NSUbiquitousKeyValueStore.makeMock()
        defaults.removeObject(forKey: "person")
        XCTAssertThrowsError(try defaults.decode(Person.self, forKey: "person"))
    }

    func testThrowsWhenInvalidDictionary() throws {
        let defaults = NSUbiquitousKeyValueStore.makeMock()
        defaults.set(["name": 99, "age": "Herbert"], forKey: "person")
        XCTAssertThrowsError(try defaults.decode(Person.self, forKey: "person"))
    }

    func testCanDecode() throws {
        let defaults = NSUbiquitousKeyValueStore.makeMock()
        defaults.set(["name": "Herbert", "age": 99], forKey: "person")

        let person = try defaults.decode(Person.self, forKey: "person")
        XCTAssertEqual(person, Person(name: "Herbert", age: 99))
    }

    func testCanEncode() throws {
        let defaults = NSUbiquitousKeyValueStore.makeMock()
        defaults.removeObject(forKey: "person")

        XCTAssertNil(defaults.object(forKey: "person"))
        try defaults.encode(Person(name: "Joyce", age: 21), forKey: "person")

        let dictionary = defaults.dictionary(forKey: "person")
        XCTAssertEqual(dictionary?["name"] as? String, "Joyce")
        XCTAssertEqual(dictionary?["age"] as? Int, 21)
    }

    func testCanEncodeOptional() throws {
        let defaults = NSUbiquitousKeyValueStore.makeMock()

        XCTAssertNil(defaults.object(forKey: "person"))
        var person: Person? = Person(name: "Joyce", age: 21)
        try defaults.encode(person, forKey: "person")
        XCTAssertNotNil(defaults.object(forKey: "person"))

        person = nil
        try defaults.encode(person, forKey: "person")
        XCTAssertNil(defaults.object(forKey: "person"))
    }

    func testCanDecodeOptional() throws {
        let defaults = NSUbiquitousKeyValueStore.makeMock()

        XCTAssertNil(defaults.object(forKey: "person"))
        XCTAssertNil(try defaults.decode(Optional<Person>.self, forKey: "person"))

        defaults.set(["name": "Herbert", "age": 99], forKey: "person")
        let person = try defaults.decode(Optional<Person>.self, forKey: "person")
        XCTAssertEqual(person, Person(name: "Herbert", age: 99))
    }
}

private struct Person: Codable, Equatable {
    var name: String
    var age: Int
}

private extension NSUbiquitousKeyValueStore {
    
    static func makeMock() -> NSUbiquitousKeyValueStore {
        return MockKeyValueStore()
    }
}

final class MockKeyValueStore: NSUbiquitousKeyValueStore {

    private var storage = [String: Any]()

    override func set(_ aDictionary: [String : Any]?, forKey aKey: String) {
        storage[aKey] = aDictionary
    }

    override func removeObject(forKey aKey: String) {
        storage[aKey] = nil
    }

    override func dictionary(forKey aKey: String) -> [String: Any]? {
        storage[aKey] as? [String: Any]
    }

    override func object(forKey aKey: String) -> Any? {
        storage[aKey]
    }
}

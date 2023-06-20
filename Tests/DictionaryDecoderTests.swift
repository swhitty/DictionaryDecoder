//
//  DictionaryDecoderTests.swift
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

@testable import DictionaryDecoder

import XCTest

final class DictionaryDecoderTests: XCTestCase {

    func testSimpleDecodeFromDictionarySucceeds() throws {
        let simple = try DictionaryDecoder().decode(Simple.self, from: ["title": "Lowlands",
                                                                        "size": 16,
                                                                        "isValid": true])

        XCTAssertEqual(simple.title, "Lowlands")
        XCTAssertEqual(simple.size, 16)
        XCTAssertEqual(simple.isValid, true)
    }

    func testNestedDecodeFromDictionarySucceeds() throws {
        let nested = try DictionaryDecoder().decode(
            Nested.self,
            from: ["name": "Sarah",
                   "simple": ["title": "Lowlands",
                              "size": 16,
                              "isValid": true] as [String: Any]]
        )

        XCTAssertEqual(nested.name, "Sarah")
        XCTAssertEqual(nested.simple.title, "Lowlands")
        XCTAssertEqual(nested.simple.size, 16)
        XCTAssertEqual(nested.simple.isValid, true)
        XCTAssertNil(nested.maybeSimple)
    }

    func testSimpleDecodeFromDictionaryFails() {
        XCTAssertThrowsError(try DictionaryDecoder().decode(Simple.self, from: ["title": "Lowlands"]))
    }

    func testSimpleDecodeFromArraySucceeds() throws {
        let simple = try DictionaryDecoder().decode([Int].self, from: [10, 20, 30])
        XCTAssertEqual(simple, [10, 20, 30])
    }

    func testSimpleDecodeFromArrayFails() {
        XCTAssertThrowsError(try DictionaryDecoder().decode([String].self, from: [10, 20, 30]))
    }

    // MARK: - KeyedContainer

    func testKeyedContainerDecodesBool() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": true])
        XCTAssertEqual(try container.decode(Bool.self, forKey: "key"), true)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100])
        XCTAssertThrowsError(try another.decode(Bool.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Bool.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesString() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": "Hola"])
        XCTAssertEqual(try container.decode(String.self, forKey: "key"), "Hola")

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100])
        XCTAssertThrowsError(try another.decode(String.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(String.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesDouble() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": 10.0])
        XCTAssertEqual(try container.decode(Double.self, forKey: "key"), 10.0)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100])
        XCTAssertThrowsError(try another.decode(Double.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Double.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesFloat() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Float(10.0)])
        XCTAssertEqual(try container.decode(Float.self, forKey: "key"), 10.0)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["int": 100,
                                                                     "overflow": Double(Float.greatestFiniteMagnitude) + 1])
        XCTAssertThrowsError(try another.decode(Float.self, forKey: "int"))
        XCTAssertThrowsError(try another.decode(Float.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(Float.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": 10])
        XCTAssertEqual(try container.decode(Int.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(Int.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt8() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Int8(10)])
        XCTAssertEqual(try container.decode(Int8.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0,
                                                                     "overflow": Int16(Int8.max) + 1])
        XCTAssertThrowsError(try another.decode(Int8.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int8.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(Int8.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt16() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Int16(10)])
        XCTAssertEqual(try container.decode(Int16.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0,
                                                                     "overflow": Int32(Int16.max) + 1])
        XCTAssertThrowsError(try another.decode(Int16.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int16.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(Int16.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt32() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Int32(10)])
        XCTAssertEqual(try container.decode(Int32.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0,
                                                                     "overflow": Int64(Int32.max) + 1])
        XCTAssertThrowsError(try another.decode(Int32.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int32.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(Int32.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt64() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Int64(10)])
        XCTAssertEqual(try container.decode(Int64.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(Int64.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int64.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt(10)])
        XCTAssertEqual(try container.decode(UInt.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt8() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt8(10)])
        XCTAssertEqual(try container.decode(UInt8.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0,
                                                                     "overflow": UInt16(UInt8.max) + 1])
        XCTAssertThrowsError(try another.decode(UInt8.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt8.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(UInt8.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt16() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt16(10)])
        XCTAssertEqual(try container.decode(UInt16.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0,
                                                                     "overflow": UInt32(UInt16.max) + 1])
        XCTAssertThrowsError(try another.decode(UInt16.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt16.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(UInt16.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt32() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt32(10),
                                                                       "overflow": UInt64(UInt32.max) + 1])
        XCTAssertEqual(try container.decode(UInt32.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt32.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt32.self, forKey: "overflow"))
        XCTAssertThrowsError(try another.decode(UInt32.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt64() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt64(10)])
        XCTAssertEqual(try container.decode(UInt64.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt64.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt64.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesData() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Data.mock])
        XCTAssertEqual(try container.decode(Data.self, forKey: "key"), Data.mock)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(Data.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Data.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesDate() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Date.distantPast])
        XCTAssertEqual(try container.decode(Date.self, forKey: "key"), Date.distantPast)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": "abc"])
        XCTAssertThrowsError(try another.decode(Date.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Date.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesURL() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": URL.mock,
                                                                       "string": URL.mock.absoluteString])
        XCTAssertEqual(try container.decode(URL.self, forKey: "key"), URL.mock)
        XCTAssertEqual(try container.decode(URL.self, forKey: "string"), URL.mock)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": "some text"])
        XCTAssertThrowsError(try another.decode(URL.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(URL.self, forKey: "missing"))
    }

    func testKeyedContainerContainsKeys() {
        let keyed = DictionaryDecoder.makeKeyedContainer(storage: ["blah": 2])

        XCTAssertTrue(keyed.contains("blah"))
        XCTAssertFalse(keyed.contains("asdf"))
    }

    func testKeyedContainerAllKeys() throws {
        enum TestKeys: CodingKey {
            case name, age, family
        }

        let test = ["name": "food", "family": "bar"]
        let keyed = DictionaryDecoder.makeKeyedContainer(storage: ["test": test])
        let nested = try keyed.nestedContainer(keyedBy: TestKeys.self, forKey: "test")

        XCTAssertEqual(Set(nested.allKeys), [.name, .family])
    }

    func testKeyedContainerDecodesNil() throws {

        let keyed = DictionaryDecoder.makeKeyedContainer(storage: ["blah": 2,
                                                                   "oops": Optional<Any>.none as Any,
                                                                   "nil": Optional<String>.none as Any,
                                                                   "another": Optional("Simon") as Any,
                                                                   "nested": ["fish": 5] as Any])

        XCTAssertTrue(try keyed.decodeNil(forKey: "oops"))
        XCTAssertTrue(try keyed.decodeNil(forKey: "nil"))
        XCTAssertFalse(try keyed.decodeNil(forKey: "another"))
        XCTAssertFalse(try keyed.decodeNil(forKey: "nested"))
        XCTAssertFalse(try keyed.decodeNil(forKey: "blah"))
        XCTAssertThrowsError(try keyed.decodeNil(forKey: "missing"))
    }

    func testKeyedContainerDecodesNestedKeyed() throws {
        let keyed = DictionaryDecoder.makeKeyedContainer(storage: ["first": ["title": "Lowlands"]])

        let first = try keyed.nestedContainer(keyedBy: AnyCodingKey.self, forKey: "first")
        XCTAssertEqual(try first.decode(String.self, forKey: "title"), "Lowlands")
    }

    func testKeyedContainerDecodesNestedUnkeyed() throws {
        let keyed = DictionaryDecoder.makeKeyedContainer(storage: ["first": ["Lowlands"]])

        var first = try keyed.nestedUnkeyedContainer(forKey: "first")
        XCTAssertEqual(try first.decode(String.self), "Lowlands")
    }

    func testKeyedContainerDecodesNestedType() throws {
        let keyed = DictionaryDecoder.makeKeyedContainer(storage:
            ["first": ["title": "Lowlands",
                       "size": 20,
                       "isValid": true] as [String: Any]
            ])

        let first = try keyed.decode(Simple.self, forKey: "first")
        XCTAssertEqual(first, Simple(title: "Lowlands", size: 20, isValid: true))

        XCTAssertThrowsError(try keyed.decode(Simple.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesNestedSingleType() throws {
        let keyed = DictionaryDecoder.makeKeyedContainer(storage: ["error": "invalid"])

        let code = try keyed.decode(ErrorCode.self, forKey: "error")
        XCTAssertEqual(code, .invalid)
    }

    func testKeyedContainerDecodesNestedUnkeyedKeyed() throws {
        let keyed = DictionaryDecoder.makeKeyedContainer(storage:
            ["list": [["title": "Lowlands",
                      "size": 20,
                       "isValid": true],
                      ["title": "Highlands",
                        "size": 100,
                        "isValid": false]] as [[String: Any]]
            ])

        let list = try keyed.decode([Simple].self, forKey: "list")

        XCTAssertEqual(list, [
            Simple(title: "Lowlands", size: 20, isValid: true),
            Simple(title: "Highlands", size: 100, isValid: false)
            ])
    }

    func testKeyedDecoderThrowsUnexpectedContainer() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["list": 5])

        let decoder = try container.superDecoder()
        XCTAssertNoThrow(try decoder.container(keyedBy: AnyCodingKey.self))
        XCTAssertThrowsError(try decoder.unkeyedContainer())
        XCTAssertNoThrow(try decoder.singleValueContainer())

        let another = try container.superDecoder(forKey: "list")
        XCTAssertThrowsError(try another.container(keyedBy: AnyCodingKey.self))
        XCTAssertThrowsError(try another.unkeyedContainer())
        XCTAssertNoThrow(try another.singleValueContainer())
    }

    // MARK: - UnkeyedContainer

    func testUnkeyedContainerDecodesNil() throws {
        var containerNone = DictionaryDecoder.makeUnkeyedContainer([Optional<Any>.none as Any])
        XCTAssertEqual(try containerNone.decodeNil(), true)

        var containerSome = DictionaryDecoder.makeUnkeyedContainer([Optional(10) as Any])
        XCTAssertEqual(try containerSome.decodeNil(), false)

        var another = DictionaryDecoder.makeUnkeyedContainer([100])
        XCTAssertThrowsError(try another.decodeNil())
    }

    func testUnkeyedContainerDecodesBool() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([true])
        XCTAssertEqual(try container.decode(Bool.self), true)

        var another = DictionaryDecoder.makeUnkeyedContainer([10])
        XCTAssertThrowsError(try another.decode(Bool.self))
    }

    func testUnkeyedContainerDecodesString() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer(["Hola"])
        XCTAssertEqual(try container.decode(String.self), "Hola")

        var another = DictionaryDecoder.makeUnkeyedContainer([10])
        XCTAssertThrowsError(try another.decode(String.self))
    }

    func testUnkeyedContainerDecodesDouble() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([10.0])
        XCTAssertEqual(try container.decode(Double.self), 10.0)

        var another = DictionaryDecoder.makeUnkeyedContainer([100])
        XCTAssertThrowsError(try another.decode(Double.self))
    }

    func testUnkeyedContainerDecodesFloat() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Float(10.0)])
        XCTAssertEqual(try container.decode(Float.self), 10.0)

        var another = DictionaryDecoder.makeUnkeyedContainer([100])
        XCTAssertThrowsError(try another.decode(Float.self))
    }

    func testUnkeyedContainerDecodesInt() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([10])
        XCTAssertEqual(try container.decode(Int.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(Int.self))
    }

    func testUnkeyedContainerDecodesInt8() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Int8(10)])
        XCTAssertEqual(try container.decode(Int8.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(Int8.self))
    }

    func testUnkeyedContainerDecodesInt16() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Int16(10)])
        XCTAssertEqual(try container.decode(Int16.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(Int16.self))
    }

    func testUnkeyedContainerDecodesInt32() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Int32(10)])
        XCTAssertEqual(try container.decode(Int32.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(Int32.self))
    }

    func testUnkeyedContainerDecodesInt64() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Int64(10)])
        XCTAssertEqual(try container.decode(Int64.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(Int64.self))
    }

    func testUnkeyedContainerDecodesUInt() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([UInt(10)])
        XCTAssertEqual(try container.decode(UInt.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(UInt.self))
    }

    func testUnkeyedContainerDecodesUInt8() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([UInt8(10)])
        XCTAssertEqual(try container.decode(UInt8.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(UInt8.self))
    }

    func testUnkeyedContainerDecodesUInt16() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([UInt16(10)])
        XCTAssertEqual(try container.decode(UInt16.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(UInt16.self))
    }

    func testUnkeyedContainerDecodesUInt32() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([UInt32(10)])
        XCTAssertEqual(try container.decode(UInt32.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(UInt32.self))
    }

    func testUnkeyedContainerDecodesUInt64() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([UInt64(10)])
        XCTAssertEqual(try container.decode(UInt64.self), 10)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(UInt64.self))
    }

    func testUnkeyedContainerDecodesData() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Data.mock])
        XCTAssertEqual(try container.decode(Data.self), Data.mock)

        var another = DictionaryDecoder.makeUnkeyedContainer([100.0])
        XCTAssertThrowsError(try another.decode(Data.self))
    }

    func testUnkeyedContainerDecodesDate() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([Date.distantPast])
        XCTAssertEqual(try container.decode(Date.self), Date.distantPast)

        var another = DictionaryDecoder.makeUnkeyedContainer(["abc"])
        XCTAssertThrowsError(try another.decode(Date.self))
    }

    func testUnkeyedContainerDecodesURL() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([URL.mock, URL.mock.absoluteString, "some text"])
        XCTAssertEqual(try container.decode(URL.self), URL.mock)
        XCTAssertEqual(try container.decode(URL.self), URL.mock)
        XCTAssertThrowsError(try container.decode(URL.self))
    }

    func testUnkeyedContainerDecodesNestedKeyed() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([["title": "Lowlands"], ["title": "Highlands"]])

        let first = try container.nestedContainer(keyedBy: AnyCodingKey.self)
        XCTAssertEqual(try first.decode(String.self, forKey: "title"), "Lowlands")

        let second = try container.nestedContainer(keyedBy: AnyCodingKey.self)
        XCTAssertEqual(try second.decode(String.self, forKey: "title"), "Highlands")
    }

    func testUnkeyedContainerDecodesNestedUnkeyed() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([[10], [20]])

        var first = try container.nestedUnkeyedContainer()
        XCTAssertEqual(try first.decode(Int.self), 10)

        var second = try container.nestedUnkeyedContainer()
        XCTAssertEqual(try second.decode(Int.self), 20)
    }

    func testUnkeyedContainerDecodesNestedType() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer(
            [["title": "Lowlands",
              "size": 20,
              "isValid": true],
             ["title": "Highlands",
              "size": 50,
              "isValid": false],
             ])

        let first = try container.decode(Simple.self)
        XCTAssertEqual(first, Simple(title: "Lowlands", size: 20, isValid: true))

        let second = try container.decode(Simple.self)
        XCTAssertEqual(second, Simple(title: "Highlands", size: 50, isValid: false))
    }

    func testUnkeyedContainerDecodesNestedSingleType() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer(["invalid", "unknown"])

        XCTAssertEqual(try container.decode(ErrorCode.self), .invalid)
        XCTAssertEqual(try container.decode(ErrorCode.self), .unknown)
    }

    func testUnkeyedGetStorageIncrementsIndex() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([10, URL.mock, 30])

        XCTAssertEqual(container.count, 3)
        XCTAssertEqual(container.currentIndex, 0)

        XCTAssertEqual(try container.decode(Int.self), 10)
        XCTAssertEqual(container.currentIndex, 1)

        XCTAssertEqual(try container.decode(URL.self), URL.mock)
        XCTAssertEqual(container.currentIndex, 2)

        XCTAssertEqual(try container.decode(Int.self), 30)
        XCTAssertEqual(container.currentIndex, 3)
        XCTAssertTrue(container.isAtEnd)
        XCTAssertThrowsError(try container.decode(Int.self))
    }

    func testSuperEncoder() throws {
        var container = DictionaryDecoder.makeUnkeyedContainer([10, true])
        XCTAssertEqual(try container.decode(Int.self), 10)

        let superContainer = try container.superDecoder().singleValueContainer()
        XCTAssertEqual(try superContainer.decode(Bool.self), true)
    }

    // MARK: - SingleContainer

    func testSingleContainerDecodesNil() throws {
        let containerNone = DictionaryDecoder.makeSingleContainer(Optional<Any>.none as Any)
        XCTAssertEqual(containerNone.decodeNil(), true)

        let containerSome = DictionaryDecoder.makeSingleContainer(Optional(10) as Any)
        XCTAssertEqual(containerSome.decodeNil(), false)

        let another = DictionaryDecoder.makeSingleContainer(100)
        XCTAssertEqual(another.decodeNil(), false)
    }

    func testSingleContainerDecodesBool() throws {
        let container = DictionaryDecoder.makeSingleContainer(true)
        XCTAssertEqual(try container.decode(Bool.self), true)

        let another = DictionaryDecoder.makeSingleContainer(100)
        XCTAssertThrowsError(try another.decode(Bool.self))
    }

    func testSingleContainerDecodesString() throws {
        let container = DictionaryDecoder.makeSingleContainer("Title")
        XCTAssertEqual(try container.decode(String.self), "Title")

        let another = DictionaryDecoder.makeSingleContainer(100)
        XCTAssertThrowsError(try another.decode(String.self))
    }

    func testSingleContainerDecodesDouble() throws {
        let container = DictionaryDecoder.makeSingleContainer(Double(10.0))
        XCTAssertEqual(try container.decode(Double.self), 10.0)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Double.self))
    }

    func testSingleContainerDecodesFloat() throws {
        let container = DictionaryDecoder.makeSingleContainer(Float(10.0))
        XCTAssertEqual(try container.decode(Float.self), 10.0)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Float.self))
    }

    func testSingleContainerDecodesInt() throws {
        let container = DictionaryDecoder.makeSingleContainer(Int(10))
        XCTAssertEqual(try container.decode(Int.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Int.self))
    }

    func testSingleContainerDecodesInt8() throws {
        let container = DictionaryDecoder.makeSingleContainer(Int8(10))
        XCTAssertEqual(try container.decode(Int8.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Int8.self))
    }

    func testSingleContainerDecodesInt16() throws {
        let container = DictionaryDecoder.makeSingleContainer(Int16(10))
        XCTAssertEqual(try container.decode(Int16.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Int16.self))
    }

    func testSingleContainerDecodesInt32() throws {
        let container = DictionaryDecoder.makeSingleContainer(Int32(10))
        XCTAssertEqual(try container.decode(Int32.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Int32.self))
    }

    func testSingleContainerDecodesInt64() throws {
        let container = DictionaryDecoder.makeSingleContainer(Int64(10))
        XCTAssertEqual(try container.decode(Int64.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Int64.self))
    }

    func testSingleContainerDecodesUInt() throws {
        let container = DictionaryDecoder.makeSingleContainer(UInt(10))
        XCTAssertEqual(try container.decode(UInt.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(UInt.self))
    }

    func testSingleContainerDecodesUInt8() throws {
        let container = DictionaryDecoder.makeSingleContainer(UInt8(10))
        XCTAssertEqual(try container.decode(UInt8.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(UInt8.self))
    }

    func testSingleContainerDecodesUInt16() throws {
        let container = DictionaryDecoder.makeSingleContainer(UInt16(10))
        XCTAssertEqual(try container.decode(UInt16.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(UInt16.self))
    }

    func testSingleContainerDecodesUInt32() throws {
        let container = DictionaryDecoder.makeSingleContainer(UInt32(10))
        XCTAssertEqual(try container.decode(UInt32.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(UInt32.self))
    }

    func testSingleContainerDecodesUInt64() throws {
        let container = DictionaryDecoder.makeSingleContainer(UInt64(10))
        XCTAssertEqual(try container.decode(UInt64.self), 10)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(UInt64.self))
    }

    func testSingleContainerDecodesData() throws {
        let container = DictionaryDecoder.makeSingleContainer(Data.mock)
        XCTAssertEqual(try container.decode(Data.self), Data.mock)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Data.self))
    }

    func testSingleContainerDecodesDate() throws {
        let container = DictionaryDecoder.makeSingleContainer(Date.distantPast)
        XCTAssertEqual(try container.decode(Date.self), Date.distantPast)

        let another = DictionaryDecoder.makeSingleContainer("100")
        XCTAssertThrowsError(try another.decode(Date.self))
    }

    func testSingleContainerDecodesURL() throws {
        let container = DictionaryDecoder.makeSingleContainer(URL.mock)
        XCTAssertEqual(try container.decode(URL.self), URL.mock)
        let string = DictionaryDecoder.makeSingleContainer(URL.mock.absoluteString)
        XCTAssertEqual(try string.decode(URL.self), URL.mock)

        let another = DictionaryDecoder.makeSingleContainer("some text")
        XCTAssertThrowsError(try another.decode(URL.self))

        let onemore = DictionaryDecoder.makeSingleContainer(10)
        XCTAssertThrowsError(try onemore.decode(URL.self))
    }

    func testSingleContainerDecodesArray() throws {
        let container = DictionaryDecoder.makeSingleContainer([10, 20, 30])
        XCTAssertEqual(try container.decode([Int].self), [10, 20, 30])

        let another = DictionaryDecoder.makeSingleContainer("other")
        XCTAssertThrowsError(try another.decode([Int].self))
    }

    func testSingleContainerDecodesDictionary() throws {
        let container = DictionaryDecoder.makeSingleContainer(["Herbert": 99])
        XCTAssertEqual(try container.decode([String: Int].self), ["Herbert": 99])

        let another = DictionaryDecoder.makeSingleContainer("other")
        XCTAssertThrowsError(try another.decode([String: Int].self))
    }

    func testSingleContainerDecodesDecodable() throws {
        let container = DictionaryDecoder.makeSingleContainer("invalid")
        XCTAssertEqual(try container.decode(ErrorCode.self), .invalid)

        let another = DictionaryDecoder.makeSingleContainer("other")
        XCTAssertThrowsError(try another.decode(ErrorCode.self))
    }

    func testDecoderUserInfo() throws {
        let decoder = DictionaryDecoder()

        decoder.userInfo = [.version: 1]
        XCTAssertEqual(try decoder.decode(Edition.self, from: [:]).version, 1)

        decoder.userInfo = [.version: 2]
        XCTAssertEqual(try decoder.decode(Edition.self, from: [:]).version, 2)
    }
}


private extension DictionaryDecoderTests {

    struct Simple: Equatable, Decodable {
        var title: String
        var size: Int
        var isValid: Bool
    }

    struct Nested: Equatable, Decodable {
        var name: String
        var simple: Simple
        var maybeSimple: Simple?
    }

    enum ErrorCode: String, Decodable {
        case invalid
        case unknown
    }
}

private extension DictionaryDecoder {

    static func makeKeyedContainer(storage: [String: Any]) -> DictionaryDecoder.KeyedContainer<AnyCodingKey> {
        return DictionaryDecoder.KeyedContainer<AnyCodingKey>(codingPath: [],
                                                              storage: storage,
                                                              userInfo: [:])
    }

    static func makeUnkeyedContainer(_ storage: [Any]) -> UnkeyedDecodingContainer {
        return DictionaryDecoder.UnkeyedContainer(codingPath: [],
                                                  storage: storage,
                                                  userInfo: [:])
    }

    static func makeUnkeyedContainer(_ storage: [[String: Any]]) -> UnkeyedDecodingContainer {
        return DictionaryDecoder.UnkeyedContainer(codingPath: [],
                                                  storage: storage,
                                                  userInfo: [:])
    }

    static func makeSingleContainer(_ value: Any) -> SingleValueDecodingContainer {
        return DictionaryDecoder.SingleContainer(value: value,
                                                 codingPath: [],
                                                 userInfo: [:])
    }
}

struct AnyCodingKey: CodingKey, ExpressibleByStringLiteral {

    typealias StringLiteralType = String

    var stringValue: String

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(stringLiteral value: String) {
        self.init(stringValue: value)
    }

    var intValue: Int?
    init?(intValue: Int) {
        self.init(stringValue: String(intValue))
        self.intValue = intValue
    }
}

extension Data {

    static var mock: Data {
        return Data(repeating: 255, count: 4)
    }
}

extension URL {

    static var mock: URL {
        return URL(string: "https://www.whileloop.com")!
    }
}

extension CodingUserInfoKey {

    static var version: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "version")!
    }
}

struct Edition: Codable {
    var version: Int

    init(version: Int) {
        self.version = version
    }

    init(from decoder: Decoder) throws {
        guard let version = decoder.userInfo[.version] as? Int else {
            throw Error.invalid
        }
        self.version = version
    }

    func encode(to encoder: Encoder) throws {
        guard
            let version = encoder.userInfo[.version] as? Int,
            version == self.version else {
            throw Error.invalid
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
    }

    enum CodingKeys: CodingKey {
        case version
    }

    enum Error: Swift.Error {
        case invalid
    }
}

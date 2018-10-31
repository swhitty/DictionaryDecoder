//
//  Copyright © 2018 Simon Whitty. All rights reserved.
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

    func testSimpleDecodeFromDictionaryFails() throws {
        XCTAssertThrowsError(try DictionaryDecoder().decode(Simple.self, from: ["title": "Lowlands"]))
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

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100])
        XCTAssertThrowsError(try another.decode(Float.self, forKey: "key"))
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

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(Int8.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int8.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt16() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Int16(10)])
        XCTAssertEqual(try container.decode(Int16.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(Int16.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(Int16.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesInt32() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": Int32(10)])
        XCTAssertEqual(try container.decode(Int32.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(Int32.self, forKey: "key"))
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

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt8.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt8.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt16() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt16(10)])
        XCTAssertEqual(try container.decode(UInt16.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt16.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt16.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt32() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt32(10)])
        XCTAssertEqual(try container.decode(UInt32.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt32.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt32.self, forKey: "missing"))
    }

    func testKeyedContainerDecodesUInt64() throws {
        let container = DictionaryDecoder.makeKeyedContainer(storage: ["key": UInt64(10)])
        XCTAssertEqual(try container.decode(UInt64.self, forKey: "key"), 10)

        let another = DictionaryDecoder.makeKeyedContainer(storage: ["key": 100.0])
        XCTAssertThrowsError(try another.decode(UInt64.self, forKey: "key"))
        XCTAssertThrowsError(try another.decode(UInt64.self, forKey: "missing"))
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
                                                                   "another": Optional("Simon") as Any])

        XCTAssertTrue(try keyed.decodeNil(forKey: "oops"))
        XCTAssertTrue(try keyed.decodeNil(forKey: "nil"))
        XCTAssertFalse(try keyed.decodeNil(forKey: "another"))
        XCTAssertThrowsError(try keyed.decodeNil(forKey: "blah"))
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
                       "isValid": true]
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
                        "isValid": false]]
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
        XCTAssertThrowsError(try decoder.singleValueContainer())

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
        var container = DictionaryDecoder.makeUnkeyedContainer([10, 20, 30])

        XCTAssertEqual(container.count, 3)
        XCTAssertEqual(container.currentIndex, 0)

        XCTAssertNoThrow(try container.decode(Int.self))
        XCTAssertEqual(container.currentIndex, 1)

        XCTAssertNoThrow(try container.decode(Int.self))
        XCTAssertEqual(container.currentIndex, 2)
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

    func testSingleContainerDecodesDecodable() throws {
        let container = DictionaryDecoder.makeSingleContainer("invalid")
        XCTAssertEqual(try container.decode(ErrorCode.self), .invalid)

        let another = DictionaryDecoder.makeSingleContainer("other")
        XCTAssertThrowsError(try another.decode(ErrorCode.self))
    }
}


private extension DictionaryDecoderTests {

    struct Simple: Equatable, Decodable {
        var title: String
        var size: Int
        var isValid: Bool
    }

    enum ErrorCode: String, Decodable {
        case invalid
        case unknown
    }
}

private extension DictionaryDecoder {

    static func makeKeyedContainer(storage: [String: Any]) -> DictionaryDecoder.KeyedContainer<AnyCodingKey> {
        return DictionaryDecoder.KeyedContainer<AnyCodingKey>(codingPath: [], storage: storage)
    }

    static func makeUnkeyedContainer(_ storage: [Any]) -> UnkeyedDecodingContainer {
        return DictionaryDecoder.UnkeyedContainer(codingPath: [], storage: storage)
    }

    static func makeSingleContainer(_ value: Any) -> SingleValueDecodingContainer {
        return DictionaryDecoder.SingleContainer(value: value, codingPath: [])
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

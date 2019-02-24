//
//  Dictionary+ExtensionTests.swift
//  DictionaryDecoder
//
//  Created by Simon Whitty on 24/02/2019.
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

final class DictionaryExtensionTests: XCTestCase {

    func testObject() {
        var dict = [String: Any]()
        dict[object: "refer"] = [
            "name": "Florence",
            "age": 101
        ]

        XCTAssertEqual(dict[object: "refer"]?[string: "name"], "Florence")
        XCTAssertEqual(dict[object: "refer"]?[int: "age"], 101)
        XCTAssertNil(dict[object: "refer"]?[object: "missing"])
        XCTAssertNil(dict[object: "missing"])
    }

    func testObjectArray() {
        var dict = [String: Any]()
        dict[objectArray: "contacts"] = [
            ["name": "Joyce", "age": 101]
        ]

        XCTAssertEqual(dict[objectArray: "contacts"]?[0][string: "name"], "Joyce")
        XCTAssertEqual(dict[objectArray: "contacts"]?[0][int: "age"], 101)
        XCTAssertNil(dict[objectArray: "missing"])
    }

    func testString() {
        var dict = [String: Any]()
        dict[string: "key"] = "Herbert"
        dict[string: "another"] = "Florence"

        XCTAssertEqual(dict[string: "key"], "Herbert")
        XCTAssertEqual(dict[string: "another"], "Florence")
        XCTAssertNil(dict[string: "missing"])
    }

    func testInt() {
        var dict = [String: Any]()
        dict[int: "key"] = 10
        dict[int: "another"] = 20

        XCTAssertEqual(dict[int: "key"], 10)
        XCTAssertEqual(dict[int: "another"], 20)
        XCTAssertNil(dict[int: "missing"])
    }

    func testUInt() {
        var dict = [String: Any]()
        dict[uint: "key"] = 10
        dict[uint: "another"] = 20

        XCTAssertEqual(dict[uint: "key"], 10)
        XCTAssertEqual(dict[uint: "another"], 20)
        XCTAssertNil(dict[uint: "missing"])
    }

    func testBool() {
        var dict = [String: Any]()
        dict[bool: "key"] = true
        dict[bool: "another"] = false

        XCTAssertEqual(dict[bool: "key"], true)
        XCTAssertEqual(dict[bool: "another"], false)
        XCTAssertNil(dict[bool: "missing"])
    }

    func testDouble() {
        var dict = [String: Any]()
        dict[double: "key"] = 100.0
        dict[double: "another"] = 200.0

        XCTAssertEqual(dict[double: "key"], 100.0)
        XCTAssertEqual(dict[double: "another"], 200.0)
        XCTAssertNil(dict[double: "missing"])
    }

    func testFloat() {
        var dict = [String: Any]()
        dict[float: "key"] = 100.0
        dict[float: "another"] = 200.0

        XCTAssertEqual(dict[float: "key"], 100.0)
        XCTAssertEqual(dict[float: "another"], 200.0)
        XCTAssertNil(dict[float: "missing"])
    }
}

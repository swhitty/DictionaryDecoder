//
//  UserDefaults+CodableTests.swift
//  DictionaryDecoder
//
//  Created by Simon Whitty on 26/11/18.
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

@testable import DictionaryDecoder

import Foundation
import XCTest

final class UserDefaultsCodableTests: XCTestCase {

    func testThrowsWhenKeyMissing() throws {
        let defaults = UserDefaults(suiteName: "mock")!
        defaults.set(nil, forKey: "person")
        XCTAssertThrowsError(try defaults.decode(Person.self, forKey: "person"))
    }

    func testThrowsWhenInvalidDictionary() throws {
        let defaults = UserDefaults(suiteName: "mock")!
        defaults.set(["name": 99, "age": "Herbert"], forKey: "person")
        XCTAssertThrowsError(try defaults.decode(Person.self, forKey: "person"))
    }

    func testCanDecode() throws {
        let defaults = UserDefaults(suiteName: "mock")!
        defaults.set(["name": "Herbert", "age": 99], forKey: "person")

        let person = try defaults.decode(Person.self, forKey: "person")
        XCTAssertEqual(person, Person(name: "Herbert", age: 99))
    }

    func testCanEncode() throws {
        let defaults = UserDefaults(suiteName: "mock")!
        defaults.set(nil, forKey: "person")

        XCTAssertNil(defaults.object(forKey: "person"))
        try defaults.encode(Person(name: "Joyce", age: 21), forKey: "person")

        let dictionary = defaults.dictionary(forKey: "person")
        XCTAssertEqual(dictionary?["name"] as? String, "Joyce")
        XCTAssertEqual(dictionary?["age"] as? Int, 21)
    }
}

private struct Person: Codable, Equatable {
    var name: String
    var age: Int
}

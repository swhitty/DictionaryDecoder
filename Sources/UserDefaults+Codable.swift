//
//  UserDefaults+Codable.swift
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
import Foundation

public extension UserDefaults {

    func encode<T: Encodable>(_ value: T, forKey key: String) throws {
        let dictionary = try DictionaryEncoder().encode(value)
        set(dictionary, forKey: key)
    }

    func encode<T: Encodable>(_ value: T?, forKey key: String) throws {
        switch value {
        case .some(let value):
            try encode(value, forKey: key)
        case .none:
            set(nil, forKey: key)
        }
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T {
        guard let dictionary = dictionary(forKey: key) else {
            throw Error.invalid
        }
        return try DictionaryDecoder().decode(type, from: dictionary)
    }

    func decode<T: Decodable>(_ type: Optional<T>.Type, forKey key: String) throws -> T? {
        guard value(forKey: key) == nil else {
            return try decode(T.self, forKey: key)
        }
        return nil
    }

    private enum Error: Swift.Error {
        case invalid
    }
}

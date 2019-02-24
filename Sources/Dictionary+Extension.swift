//
//  Dictionary+Extension.swift
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

public extension Dictionary where Key == String, Value == Any {

    subscript(object key: Key) -> [String: Any]? {
        get {
            return self[key] as? [String: Any]
        }
        set {
            self[key] = newValue
        }
    }

    subscript(objectArray key: Key) -> [[String: Any]]? {
        get {
            return self[key] as? [[String: Any]]
        }
        set {
            self[key] = newValue
        }
    }

    subscript(string key: Key) -> String? {
        get {
            return self[key] as? String
        }
        set {
            self[key] = newValue
        }
    }

    subscript(int key: Key) -> Int? {
        get {
            return self[key] as? Int
        }
        set {
            self[key] = newValue
        }
    }

    subscript(uint key: Key) -> UInt? {
        get {
            return self[key] as? UInt
        }
        set {
            self[key] = newValue
        }
    }

    subscript(bool key: Key) -> Bool? {
        get {
            return self[key] as? Bool
        }
        set {
            self[key] = newValue
        }
    }

    subscript(double key: Key) -> Double? {
        get {
            return self[key] as? Double
        }
        set {
            self[key] = newValue
        }
    }

    subscript(float key: Key) -> Float? {
        get {
            return self[key] as? Float
        }
        set {
            self[key] = newValue
        }
    }
}

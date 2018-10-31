[![Travis](https://img.shields.io/travis/swhitty/DictionaryDecoder.svg)](https://travis-ci.org/swhitty/DictionaryDecoder)
[![License](https://img.shields.io/badge/license-zlib-lightgrey.svg)](https://opensource.org/licenses/Zlib)
[![Twitter](https://img.shields.io/badge/twitter-@simonwhitty-blue.svg)](http://twitter.com/simonwhitty)

# DictionaryDecoder
A Swift library for encoding and decoding `Codable` types to `[String: Any]`.

## Usage

```swift
struct Foo: Decodable {
   var name: String
   var age: Int
}

let foo = try DictionaryDecoder().decode(Foo.self, from: ["name": "Foo", "age": 99])
```
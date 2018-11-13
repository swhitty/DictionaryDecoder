[![Travis](https://img.shields.io/travis/swhitty/DictionaryDecoder.svg)](https://travis-ci.org/swhitty/DictionaryDecoder)
[![License](https://img.shields.io/badge/license-zlib-lightgrey.svg)](https://opensource.org/licenses/Zlib)
[![Twitter](https://img.shields.io/badge/twitter-@simonwhitty-blue.svg)](http://twitter.com/simonwhitty)

# DictionaryDecoder
A Swift library for serializing `Codable` types to and from `[String: Any]`.

## Usage

```swift
struct Person: Decodable {
   var name: String
   var age: Int
}

let person = try DictionaryDecoder().decode(Person.self, from: ["name": "Herbert", "age": 99])
```

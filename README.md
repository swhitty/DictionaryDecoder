[![Travis](https://img.shields.io/travis/swhitty/DictionaryDecoder.svg)](https://travis-ci.org/swhitty/DictionaryDecoder)
[![CodeCov](https://codecov.io/gh/swhitty/DictionaryDecoder/branch/master/graphs/badge.svg)](https://codecov.io/gh/swhitty/DictionaryDecoder/branch/master)
[![Swift 4.2](https://img.shields.io/badge/swift-4.2-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
[![Twitter](https://img.shields.io/badge/twitter-@simonwhitty-blue.svg)](http://twitter.com/simonwhitty)

# DictionaryDecoder
A Swift library for serializing `Codable` types to and from `[String: Any]` and `UserDefaults`.

## Usage
```swift
struct Person: Codable {
   var name: String
   var age: Int
}

let person = try DictionaryDecoder().decode(Person.self, from: ["name": "Herbert", "age": 99])
```

## UserDefaults
Store any `Encodable` type to UserDefaults.
```swift
let person = Person(name: "Herbert", age: 99)
try UserDefaults.standard.encode(person, forKey: "owner")
```

Retrieve any `Decodable` type from UserDefaults.
```swift
let owner = try UserDefaults.standard.decode(Person.self, forKey: "owner")
```

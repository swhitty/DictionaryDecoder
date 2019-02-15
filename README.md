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

// Decode from [String: Any]
let person = try DictionaryDecoder()
                  .decode(Person.self,
                          from: [
                            "name": "Herbert",
                            "age": 99
                          ])

// Encode to [String: Any]
let dict = try DictionaryEncoder().encode(person)
```

## UserDefaults
Store and retrieve any `Codable` type within UserDefaults.
```swift
let person = Person(name: "Herbert", age: 99)

// Persist values
try UserDefaults.standard.encode(person, forKey: "owner")

// Retrieve values
let owner = try UserDefaults.standard.decode(Person.self, forKey: "owner")
```

Types are persisted with friendly `[String: Any]` representations;

```swift
let defaults = UserDefaults.standard.dictionaryRepresentationn()
let owner = defaults["owner"]
// owner == ["name": "Herbert", "age": 99]
```
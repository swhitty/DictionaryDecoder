[![Build](https://github.com/swhitty/DictionaryDecoder/actions/workflows/build.yml/badge.svg)](https://github.com/swhitty/DictionaryDecoder/actions/workflows/build.yml)
[![CodeCov](https://codecov.io/gh/swhitty/DictionaryDecoder/branch/main/graphs/badge.svg)](https://codecov.io/gh/swhitty/DictionaryDecoder/branch/main)
[![Swift 5.8](https://img.shields.io/badge/swift-5.7%20–%205.8-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
[![Twitter](https://img.shields.io/badge/twitter-@simonwhitty-blue.svg)](http://twitter.com/simonwhitty)

# DictionaryDecoder
A Swift library for serializing `Codable` types to and from `[String: Any]` and `UserDefaults`.

🚨This library has been moved to [KeyValueCoder](https://github.com/swhitty/KeyValueCoder)

## Usage
```swift
struct Person: Codable {
   var name: String
   var age: Int
}

// Decode from [String: Any]
let person = try DictionaryDecoder().decode(
  Person.self, 
  from: ["name": "Herbert", "age": 99]
)

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

Types are persisted in a friendly `[String: Any]` representation;

```swift
let defaults = UserDefaults.standard.dictionaryRepresentation()
let owner = defaults["owner"]
// owner == ["name": "Herbert", "age": 99]
```

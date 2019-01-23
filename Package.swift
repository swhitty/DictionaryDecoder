// swift-tools-version:4.2
import PackageDescription


let exclude: [String]
#if os(Linux)
	exclude = [
		"NSUbiquitousKeyValueStore+Codable.swift",
		"NSUbiquitousKeyValueStore+CodableTests.swift"
	]
#else
	exclude = []
#endif

let package = Package(
    name: "DictionaryDecoder",
    products: [
        .library(
            name: "DictionaryDecoder",
            targets: ["DictionaryDecoder"]
        ),
    ],
    targets: [
        .target(name: "DictionaryDecoder",
				path: "Sources",
				exclude: exclude),
        .testTarget(name: "DictionaryDecoderTests",
					dependencies: ["DictionaryDecoder"],
					path: "Tests",
					exclude: exclude),
    ]
)


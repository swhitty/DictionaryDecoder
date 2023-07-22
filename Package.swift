// swift-tools-version:5.7
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
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v11), .watchOS(.v4)
    ],
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

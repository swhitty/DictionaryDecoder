// swift-tools-version:4.2
import PackageDescription

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
				path: "Sources"),
        .testTarget(name: "DictionaryDecoderTests",
					dependencies: ["DictionaryDecoder"],
					path: "Tests"),
    ]
)


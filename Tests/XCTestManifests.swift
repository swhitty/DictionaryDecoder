import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DictionaryDecoderTests.allTests),
		testCase(DictionaryEncoderTests.allTests),
    ]
}
#endif
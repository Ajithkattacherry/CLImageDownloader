import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CLImageDownloaderTests.allTests),
    ]
}
#endif

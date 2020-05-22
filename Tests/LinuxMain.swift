import XCTest

import DebugAdapterProtocolTests

var tests = [XCTestCaseEntry]()
tests += DebugAdapterProtocolTests.allTests()
XCTMain(tests)
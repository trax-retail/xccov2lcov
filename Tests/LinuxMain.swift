import XCTest

import xccov2lcovTests

var tests = [XCTestCaseEntry]()
tests += xccov2lcovTests.allTests()
XCTMain(tests)

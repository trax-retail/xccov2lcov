import XCTest
@testable import XCCovLib

final class xccov2lcovTests: XCTestCase {

    func testFunctionSimple() {
        let function = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn")

        let expected = """
                       DA:5,4
                       """

        XCTAssertEqual(function.lcov(context: XCCovContext()), expected)
    }

    func testFunctionFull() {
        let function = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn")

        let expected = """
                       FN:5,fn
                       FNDA:4,fn
                       FNF:2
                       FNH:1
                       """

        XCTAssertEqual(function.lcov(context: XCCovContext(mode: .full)), expected)
    }

    func testUnnamedFunction() {
        let function = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "")

        let expected = """
                       DA:5,4
                       """

        XCTAssertEqual(function.lcov(context: XCCovContext()), expected)
    }

    func testFileSimple() {
        let function = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn")
        let file = XCCovFile(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "filename", path: "filepath", functions: [function])

        let expected = """
                       SF:filepath
                       DA:5,4
                       end_of_record
                       """

        XCTAssertEqual(file.lcov(context: XCCovContext()), expected)
    }

    func testFileFull() {
        let function = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn")
        let file = XCCovFile(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "filename", path: "filepath", functions: [function])

        let expected = """
                       SF:filepath
                       FN:5,fn
                       FNDA:4,fn
                       FNF:2
                       FNH:1
                       LF:2
                       LH:1
                       end_of_record
                       """

        XCTAssertEqual(file.lcov(context: XCCovContext(mode: .full)), expected)
    }

    func testTargetSimple() {
        let fn1 = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn1")
        let fn2 = XCCovFunction(coveredLines: 6, executableLines: 7, lineCoverage: 8.5, executionCount: 9, lineNumber: 10, name: "fn2")
        let file = XCCovFile(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "filename", path: "filepath", functions: [fn1, fn2])
        let target = XCCovTarget(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "targetname", buildProductPath: "buildpath", files: [file])

        let expected = """
                       SF:filepath
                       DA:5,4
                       DA:10,9
                       end_of_record
                       """

        XCTAssertEqual(target.lcov(context: XCCovContext()), expected)
    }

    func testTargetFullMode () {
        let fn1 = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn1")
        let fn2 = XCCovFunction(coveredLines: 6, executableLines: 7, lineCoverage: 8.5, executionCount: 9, lineNumber: 10, name: "fn2")
        let file = XCCovFile(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "filename", path: "filepath", functions: [fn1, fn2])
        let target = XCCovTarget(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "targetname", buildProductPath: "buildpath", files: [file])

        let expected = """
                       SF:filepath
                       FN:5,fn1
                       FNDA:4,fn1
                       FNF:2
                       FNH:1
                       FN:10,fn2
                       FNDA:9,fn2
                       FNF:7
                       FNH:6
                       LF:2
                       LH:1
                       end_of_record
                       """

        XCTAssertEqual(target.lcov(context: XCCovContext(mode: .full)), expected)
    }

    func testTargetFiltering() {
        let fn1 = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "")
        let f1 = XCCovFile(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "f1", path: "f1path", functions: [fn1])
        let f2 = XCCovFile(coveredLines: 4, executableLines: 5, lineCoverage: 6.5, name: "f2", path: "f2path", functions: [fn1])
        let t1 = XCCovTarget(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "t1", buildProductPath: "buildpath", files: [f1])
        let t2 = XCCovTarget(coveredLines: 4, executableLines: 5, lineCoverage: 6.5, name: "t2", buildProductPath: "buildpath", files: [f2])
        let data = XCCovData(coveredLines: 7, executableLines: 8, lineCoverage: 9.5, targets: [t1, t2])

        let expected = """
                       SF:f1path
                       DA:5,4
                       end_of_record
                       """

        let actual = data.lcov(context: XCCovContext(includedTargets: ["t1"]))
        XCTAssertEqual(actual, expected)
    }

    func testPathTrimming() {

        let function = XCCovFunction(coveredLines: 1, executableLines: 2, lineCoverage: 3.0, executionCount: 4, lineNumber: 5, name: "fn")
        let file = XCCovFile(coveredLines: 1, executableLines: 2, lineCoverage: 3.5, name: "filename", path: "/foo/bar/baz.json", functions: [function])

        let expected = """
                       SF:baz.json
                       DA:5,4
                       end_of_record
                       """

        let actual = file.lcov(context: XCCovContext(trimPath: "/foo/bar/"))
        XCTAssertEqual(actual, expected)
    }

    static var allTests = [(
        "testExample",
        testFunctionSimple,
        testFunctionFull,
        testUnnamedFunction,
        testFileSimple,
        testFileFull,
        testTargetSimple,
        testTargetFiltering,
        testPathTrimming),
    ]
}

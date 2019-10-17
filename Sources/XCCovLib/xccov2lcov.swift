//
// Created by David Whetstone on 10/16/19.
// Copyright (c) 2019 Trax. All rights reserved.
//

import Foundation

public
struct XCCovContext {
    public let includedTargets: [String]
    public let trimPath: String

    public init(includedTargets: [String] = [], trimPath: String = "") {
        self.includedTargets = includedTargets
        self.trimPath = trimPath
    }
}

extension XCCovData {
    public func lcov(context: XCCovContext) -> String {
        includedTargets(context.includedTargets)
            .map { $0.lcov(context: context) }
            .joined(separator: "\n")
    }

    private func includedTargets(_ includeTargets: [String]) -> [XCCovTarget] {
        includeTargets.isEmpty
            ? targets
            : targets.filter { includeTargets.contains($0.name) }
    }
}

extension XCCovTarget {
    public func lcov(context: XCCovContext) -> String {
        files.map { $0.lcov(context: context) }.joined(separator: "\n")
    }
}

extension XCCovFile {
    public func lcov(context: XCCovContext) -> String {
        """
        SF:\(path.trimmingPrefix(context.trimPath))
        \(functions.map { $0.lcov(context: context)}.joined(separator: "\n"))
        LF:\(executableLines)
        LH:\(coveredLines)
        end_of_record
        """
    }
}

extension XCCovFunction {
    public func lcov(context: XCCovContext) -> String {
        name.isEmpty ? unnamedFunction : namedFunction
    }

    private var namedFunction: String {
        """
        FN:\(lineNumber), \(name)
        FNDA:\(executionCount), \(name)
        FNF:\(executableLines)
        FNH:\(coveredLines)
        """
    }

    private var unnamedFunction: String {
        "DA:\(lineNumber), \(executionCount)"
    }
}

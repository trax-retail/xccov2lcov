//
// Created by David Whetstone on 10/16/19.
// Copyright (c) 2019 Trax. All rights reserved.
//

import Foundation

public
protocol XCCovBase {
    var coveredLines: Int { get }
    var executableLines: Int { get }
    var lineCoverage: Double { get }
}

public
struct XCCovData: XCCovBase, Decodable {
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    public let targets: [XCCovTarget]
}

public
struct XCCovTarget: XCCovBase, Decodable {
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    public let name: String
    public let buildProductPath: String
    public let files: [XCCovFile]
}

public
struct XCCovFile: XCCovBase, Decodable {
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    public let name: String
    public let path: String
    public let functions: [XCCovFunction]
}

public
struct XCCovFunction: XCCovBase, Decodable {
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    public let executionCount: Int
    public let lineNumber: Int
    public let name: String
}


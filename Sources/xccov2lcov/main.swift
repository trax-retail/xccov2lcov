//
//  main.swift
//  xccov2lcov
//
//  Created by David Whetstone on 10/16/19.
//  Copyright © 2019 Trax. All rights reserved.
//

import Foundation
import Commander
import XCCovLib

struct CmdError: Error, CustomStringConvertible {
    let description: String
}

command(
    Argument<String>("inputFilename", description: "Input filename (output of `xccov view --report --json file.xcresult`)"),
    Option("trim-path", default: "", description: "Path to trim from start of paths in input file"),
    Option<[String]>("include-targets", default: [], description: "Targets to include in output (default: all targets)")
) {
    inputFilename, trimPath, includeTargets in

    guard FileManager().isReadableFile(atPath: inputFilename) else { throw CmdError(description: "Cannot read input file: \(inputFilename)") }
    let context = XCCovContext(includedTargets: includeTargets, trimPath: trimPath)
    let data = try Data(contentsOf: URL(fileURLWithPath: inputFilename))
    let xccovData = try JSONDecoder().decode(XCCovData.self, from: data)
    print(xccovData.lcov(context: context))

}.run()


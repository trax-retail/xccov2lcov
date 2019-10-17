//
// Created by David Whetstone on 10/16/19.
// Copyright (c) 2019 Trax. All rights reserved.
//

import Foundation

extension String {
    func trimmingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}



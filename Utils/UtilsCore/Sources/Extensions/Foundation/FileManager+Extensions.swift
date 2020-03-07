//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public extension FileManager {
    func removeIfExists(at url: URL) throws {
        if fileExists(atPath: url.path) {
            try removeItem(at: url)
        }
    }

    func mkdirp(at url: URL) throws {
        if fileExists(atPath: url.path) {
            return
        }

        try createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    func rewrite(data: Data, to url: URL) throws {
        try removeIfExists(at: url)
        try data.write(to: url)
    }
}

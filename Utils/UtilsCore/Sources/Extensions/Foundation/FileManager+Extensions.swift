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

    @available(*, deprecated, message: "use save(data:to:) instead")
    func rewrite(data: Data, to url: URL) throws {
        try removeIfExists(at: url)
        try data.write(to: url)
    }
    
    func save(data: Data, to url: URL) throws {
        try removeIfExists(at: url)
        try mkdirp(at: url.deletingLastPathComponent())
        try data.write(to: url, options: [.atomic])
    }
    
    @available(iOS, introduced: 16.0)
    func removeFiles(in directory: URL, except: Set<String> = []) throws {
        try contentsOfDirectory(atPath: directory.path)
            .filter {
                !except.contains($0)
            }
            .forEach { file in
                print("removing file: \(file)")
                try removeItem(at: directory.appending(component: file))
            }
    }
}

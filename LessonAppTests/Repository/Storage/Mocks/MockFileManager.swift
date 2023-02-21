import Foundation
import XCTest
@testable import LessonApp

class MockFileManager: FileManager {
    var directoryURLs: [URL]?
    var fileExists: Bool = false

    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return directoryURLs ?? [URL(string: "test")!]
    }

    override func moveItem(at srcURL: URL, to dstURL: URL) throws {}

    override func fileExists(atPath path: String) -> Bool {
        return fileExists
    }
}

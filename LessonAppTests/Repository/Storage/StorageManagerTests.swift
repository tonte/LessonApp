import Foundation
import XCTest
@testable import LessonApp

class StorageManagerTests: XCTestCase {
    var storageManager: StorageManager?

    func setupStorageManager(_ fileManager: MockFileManager = .init()) {
        storageManager = .init(fileManager: fileManager)
    }

    func testRetrieveFileSuccess() {
        let fileManager = MockFileManager()
        fileManager.fileExists = true
        setupStorageManager(fileManager)
        guard let storageManager = storageManager, let url = URL(string: "test") else {
            return
        }
        XCTAssert(storageManager.retrieveFile(url: url) == url)
    }

    func testRetrieveFileFailure() {
        let fileManager = MockFileManager()
        fileManager.fileExists = false
        setupStorageManager(fileManager)
        guard let storageManager = storageManager, let url = URL(string: "test") else {
            return
        }
        XCTAssertNil(storageManager.retrieveFile(url: url))
    }

    func testGetStorageDirectoryURL() {
        let fileManager = MockFileManager()
        fileManager.directoryURLs =  [URL(string: "testStorage")!]
        setupStorageManager(fileManager)
        guard let storageManager = storageManager else {
            return
        }
        XCTAssert(storageManager.getStorageDirectoryURL() ==  URL(string: "testStorage"))
    }
}



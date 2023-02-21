import Foundation
@testable import LessonApp

class MockStorageManager: StorageManagerProtocol {
    var storedFileUrl: URL?
    var storageDirectoryURL: URL?
    var fileStoredSuccesfully: Bool = false

    func storeFile(url: URL, to: URL) {
        fileStoredSuccesfully = true
    }

    func retrieveFile(url: URL) -> URL? {
        return storedFileUrl
    }

    func getStorageDirectoryURL() -> URL? {
        return storageDirectoryURL
    }
}

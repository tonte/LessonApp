import Foundation

protocol StorageManagerProtocol {
    func storeFile(url: URL, to: URL)
    func retrieveFile(url: URL) -> URL?
    func getStorageDirectoryURL() -> URL?
}

class StorageManager: StorageManagerProtocol {
    var fileManager: FileManager?

    init(fileManager: FileManager = FileManager.default ) {
        self.fileManager = fileManager
    }
    func storeFile(url: URL, to: URL) {
        _ = try? fileManager?.moveItem(at: url, to: to)
    }

    func retrieveFile(url: URL) -> URL? {
        guard let fileManager = fileManager, fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        return url
    }

    func getStorageDirectoryURL() -> URL? {
        return fileManager?.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}

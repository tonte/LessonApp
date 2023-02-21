import Foundation

protocol LessonsStorageManagerProtocol {
    func generateFileURLForLessonVideo(_ lesson: Lesson) -> URL?
    func retrieveLesson(_ lesson: Lesson) -> URL?
    func storeLesson(_ lesson: Lesson, from: URL)
}

class LessonsStorageManager: LessonsStorageManagerProtocol {
    var storageManager: StorageManagerProtocol

    init(
        storageManager: StorageManagerProtocol = StorageManager()
    ) {
        self.storageManager = storageManager
    }

    func generateFileURLForLessonVideo(_ lesson: Lesson) -> URL? {
        if let documentsUrl:URL =  storageManager.getStorageDirectoryURL() {
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(lesson.id).mp4")
            return destinationFileUrl
        }
        return nil
    }

    func retrieveLesson(_ lesson: Lesson) -> URL? {
        guard let url = generateFileURLForLessonVideo(lesson) else { return nil }
        return storageManager.retrieveFile(url: url)
    }

    func storeLesson(_ lesson: Lesson, from: URL) {
        guard let url = generateFileURLForLessonVideo(lesson) else { return }
        storageManager.storeFile(url: from, to: url)
    }


}

import Foundation
@testable import LessonApp
class MockLessonsDownloadManager: LessonsDownloadManagerProtocol {
    var delegate: LessonsDownloadManagerDelegate?
    
    var isLessonDownloading: Bool = false

    func downloadLesson(lesson: Lesson) {
        self.isLessonDownloading = true
    }

    func cancelLessonDownload(lesson: Lesson) {
        self.isLessonDownloading = false
    }

    func isLessonDownloading(_ lesson: Lesson) -> Bool {
        return self.isLessonDownloading
    }
}

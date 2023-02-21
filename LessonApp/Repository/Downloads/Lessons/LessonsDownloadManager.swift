import Foundation


protocol LessonsDownloadManagerDelegate {
    func downloadProgressChanged(percentage: Float, for lesson: Lesson?)
    func downloadComplete(for lesson: Lesson)
}

protocol LessonsDownloadManagerProtocol {
    func downloadLesson(lesson: Lesson)
    func cancelLessonDownload(lesson: Lesson)
    func isLessonDownloading(_ lesson: Lesson) -> Bool
    var delegate: LessonsDownloadManagerDelegate? { get set }

}

class LessonsDownloadManager: LessonsDownloadManagerProtocol {
    private var lessons: [Lesson] = []
    private var downloadManager: DownloadManagerProtocol
    private var storageManager: LessonsStorageManagerProtocol
    var delegate: LessonsDownloadManagerDelegate?

    init(
        downloadManager: DownloadManagerProtocol = DownloadManager(),
        storageManager: LessonsStorageManagerProtocol = LessonsStorageManager()
    ) {
        self.downloadManager = downloadManager
        self.storageManager = storageManager
        self.downloadManager.delegate = self
    }

    func downloadLesson(lesson: Lesson) {
        lessons.append(lesson)
        guard let url = URL(string: lesson.videoURL) else { return }
        downloadManager.download(from: url)
    }

    func cancelLessonDownload(lesson: Lesson) {
        lessons.removeAll(where: { $0 == lesson })
        guard let url = URL(string: lesson.videoURL) else { return }
        downloadManager.cancelDownload(from: url)
    }

    func isLessonDownloading(_ lesson: Lesson) -> Bool {
        return lessons.contains(lesson)
    }

}
extension LessonsDownloadManager: DownloadManagerDelegate {
    func downloadProgressChanged(percentage: Float, downloadUrl: URL?) {
        for lesson in lessons {
            if let url = URL(string: lesson.videoURL) {
                if url == downloadUrl {
                    delegate?.downloadProgressChanged(percentage: percentage, for: lesson)
                }
            }
        }
    }

    func downloadComplete(from: URL?, to: URL?) {
        for (index,lesson) in lessons.enumerated() {
            if let url = URL(string: lesson.videoURL) {
                if url == from {
                    guard let temporaryURL = to else { return }
                    storageManager.storeLesson(lesson, from: temporaryURL)
                    lessons.remove(at: index)
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.downloadComplete(for: lesson)
                    }
                    return
                }
            }
        }
    }
}

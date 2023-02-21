import Foundation
import Combine

protocol LessonDetailsViewModelProtocol {
    func fetchLessonUIModel() -> LessonDetailsView.UiModel
    func showNextLesson()
    func getLessonVideo() -> URL?
    func downloadVideo()
}

class LessonDetailsViewModel: LessonDetailsViewModelProtocol {
    var lesson: Lesson
    var lessons: [Lesson]

    @Published var isLessonDownloading: Bool = false
    @Published var downloadProgress: Float = .zero


    var uiMapper: LessonDetailsDomainToUIModelMapper
    var downloadManager: LessonsDownloadManagerProtocol
    var storageManager: LessonsStorageManagerProtocol

    init (
        lesson: Lesson,
        lessons: [Lesson] = [],
        uiMapper: LessonDetailsDomainToUIModelMapper = .init(),
        downloadManager: LessonsDownloadManagerProtocol = LessonsDownloadManager(),
        storageManager: LessonsStorageManagerProtocol = LessonsStorageManager()
    ) {
        self.lesson = lesson
        self.lessons = lessons
        self.uiMapper = uiMapper
        self.downloadManager = downloadManager
        self.storageManager = storageManager
        self.downloadManager.delegate = self
    }

    func fetchLessonUIModel() -> LessonDetailsView.UiModel {
        var uiModel = uiMapper.map(lesson)
        uiModel.downloadState = .notDownloaded
        if checkIfLessonIsDownloaded() {
            uiModel.downloadState = .completed
        }
        else if downloadManager.isLessonDownloading(lesson) {
            uiModel.downloadState = .downloading
        }
        uiModel.isNextLessonButtonHidden = (getNextLesson() == nil)
        return uiModel
    }

    func getLessonVideo() -> URL? {
        if let downloadedFileUrl = storageManager.retrieveLesson(lesson) {
            return URL(fileURLWithPath: downloadedFileUrl.path)
        }
        return URL(string: lesson.videoURL)
    }

    func showNextLesson() {
        guard let nextLesson = getNextLesson() else { return }
        lesson = nextLesson
    }

    private func getNextLesson() -> Lesson? {
        guard let lessonIndex = lessons.firstIndex(of: lesson) else { return nil }
        if (lessonIndex + 2) <= lessons.count {
            return lessons[lessonIndex + 1]
        }
        return nil
    }

    func downloadVideo() {
        downloadManager.downloadLesson(lesson: lesson)
        self.downloadProgress = .zero
        self.isLessonDownloading = true
    }

    func checkIfLessonIsDownloaded() -> Bool {
        return storageManager.retrieveLesson(lesson) != nil
    }

    func cancelDownload() {
        downloadManager.cancelLessonDownload(lesson: lesson)
        self.isLessonDownloading = false
    }
}

extension LessonDetailsViewModel: LessonsDownloadManagerDelegate {
    func downloadProgressChanged(percentage: Float, for lesson: Lesson?) {
        guard let lesson = lesson else {
            return
        }
        if self.lesson == lesson {
            self.downloadProgress = percentage
        }
    }

    func downloadComplete(for lesson: Lesson) {
        if self.lesson == lesson {
            self.isLessonDownloading = false
            self.downloadProgress = .zero
        }
    }
}

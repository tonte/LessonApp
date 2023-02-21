import XCTest
@testable import LessonApp

class LessonDetailsViewModelTests: XCTestCase {
    var viewModel: LessonDetailsViewModel?

    let sampleLessons: [Lesson] = [
        Lesson(id: 950, name: "The Key To Success In iPhone Photography", description: "adssad", thumbnail: "addasd", videoURL: "adsasdasd"),
        Lesson(id: 7991, name: "How To Choose The Correct iPhone Camera Lens", description: "saddhsiasda", thumbnail: "dajdsjnd", videoURL: "adkskdsmak")
    ]

    let expectedUiModel: LessonDetailsView.UiModel = .init(
        thumbnailUrl: "addasd",
        titleLabel: "The Key To Success In iPhone Photography",
        descriptionLabel: "adssad",
        videoURL: "adsasdasd",
        downloadState: .notDownloaded,
        isNextLessonButtonHidden: false
    )

    func setUpViewModel(
        storageManager: MockLessonsStorageManager = .init(),
        downloadManager: MockLessonsDownloadManager = .init()
    ) {
        viewModel = LessonDetailsViewModel.init(
            lesson: sampleLessons[0],
            lessons: sampleLessons,
            downloadManager: downloadManager,
            storageManager: storageManager
        )
    }

    func testFetchLessonUIModel() {
        let mockStorageManager = MockLessonsStorageManager()
        mockStorageManager.lessonUrl = nil
        let mockDownloadManager = MockLessonsDownloadManager()
        mockDownloadManager.isLessonDownloading = false

        setUpViewModel(storageManager: mockStorageManager, downloadManager: mockDownloadManager)

        guard let viewModel = viewModel else {
            return
        }

        let testUiModel = viewModel.fetchLessonUIModel()

        XCTAssertTrue(testUiModel.thumbnailUrl == expectedUiModel.thumbnailUrl)
        XCTAssertTrue(testUiModel.titleLabel == expectedUiModel.titleLabel)
        XCTAssertTrue(testUiModel.descriptionLabel == expectedUiModel.descriptionLabel)
        XCTAssertTrue(testUiModel.videoURL == expectedUiModel.videoURL)
        XCTAssertTrue(testUiModel.downloadState == expectedUiModel.downloadState)
        XCTAssertTrue(testUiModel.isNextLessonButtonHidden == expectedUiModel.isNextLessonButtonHidden)
    }

    func testGetLessonVideoFromStorage() {
        let mockStorageManager = MockLessonsStorageManager()
        guard let lessonURl =  URL(string: sampleLessons[0].videoURL) else { return }
        mockStorageManager.lessonUrl = lessonURl
        let mockDownloadManager = MockLessonsDownloadManager()
        setUpViewModel(storageManager: mockStorageManager, downloadManager: mockDownloadManager)
        guard let viewModel = viewModel else {
            return
        }
        XCTAssertTrue(viewModel.getLessonVideo() == URL(fileURLWithPath: lessonURl.path))
    }

    func testGetLessonVideoFromURL() {
        let mockStorageManager = MockLessonsStorageManager()
        mockStorageManager.lessonUrl = nil
        let mockDownloadManager = MockLessonsDownloadManager()
        setUpViewModel(storageManager: mockStorageManager, downloadManager: mockDownloadManager)
        guard let viewModel = viewModel else {
            return
        }
        XCTAssertTrue(viewModel.getLessonVideo() == URL(string: sampleLessons[0].videoURL))
    }

    func testShowNextLesson() {
        setUpViewModel()
        guard let viewModel = viewModel else {
            return
        }
        viewModel.showNextLesson()
        XCTAssertTrue(viewModel.lesson == sampleLessons[1])
    }

    func testDownloadVideo() {
        setUpViewModel()
        guard let viewModel = viewModel else {
            return
        }
        viewModel.downloadVideo()
        XCTAssertTrue(viewModel.downloadManager.isLessonDownloading(sampleLessons[0]) == true)
    }

    func testCheckIfLessonIsDownloaded() {
        let mockStorageManager = MockLessonsStorageManager()
        guard let lessonURl =  URL(string: sampleLessons[0].videoURL) else { return }
        mockStorageManager.lessonUrl = lessonURl
        setUpViewModel(storageManager: mockStorageManager)
        guard let viewModel = viewModel else {
            return
        }
        XCTAssertTrue(viewModel.checkIfLessonIsDownloaded())
    }

    func testCancelDownload() {
        setUpViewModel()
        guard let viewModel = viewModel else {
            return
        }
        viewModel.downloadVideo()
        viewModel.cancelDownload()
        XCTAssertFalse(viewModel.downloadManager.isLessonDownloading(sampleLessons[0]) == true)
    }

    func testDownloadComplete() {
        setUpViewModel()
        guard let viewModel = viewModel else {
            return
        }
        viewModel.downloadVideo()
        viewModel.downloadComplete(for: sampleLessons[0])
        XCTAssertFalse(viewModel.isLessonDownloading)
    }

    func testDownloadProgressUpdating() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.downloadVideo()
        viewModel.downloadProgressChanged(percentage: 20.0, for: sampleLessons[0])
        XCTAssertTrue(viewModel.downloadProgress == 20.0)
    }

}




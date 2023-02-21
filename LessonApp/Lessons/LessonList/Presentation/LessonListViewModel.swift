import Foundation
import Combine

protocol LessonListViewModelProtocol: ObservableObject {
    func fetchLessons()
}

class LessonListViewModel: LessonListViewModelProtocol {

    @Published var lessons: [Lesson] = []
    @Published var error: Error?

    var requestManager: LessonsRequestManagerProtocol?
    var uiMapper = LessonDomainModelToUiModelMapper()

    init() {
        self.requestManager = LessonsRequestManager(
            requestManager: WebRequestManager()
        )
    }

    init(requestManager: LessonsRequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func fetchLessons() {
        requestManager?.fetchLessons { [weak self] result in
            switch(result) {
            case .success(let lessons):
                self?.lessons = lessons
            case .failure(let error):
                self?.error = error
            }
        }
    }
}

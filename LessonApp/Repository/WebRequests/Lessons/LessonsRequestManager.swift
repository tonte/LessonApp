import Foundation

protocol LessonsRequestManagerProtocol {
    func fetchLessons(_ completion: @escaping WebRequestCompletionHandler<[Lesson]>)
}

class LessonsRequestManager: LessonsRequestManagerProtocol {
    var requestManager: WebRequestManagerProtocol?

    init(requestManager: WebRequestManagerProtocol = WebRequestManager()) {
        self.requestManager = requestManager
    }

    public func fetchLessons(_ completion: @escaping WebRequestCompletionHandler<[Lesson]>) {
        makefetchLessonsRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response.lessons))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func makefetchLessonsRequest(
        _ completion: @escaping WebRequestCompletionHandler<FetchLessonsWebResponse>
    ) {
        requestManager?.load(
            url: .fetchLessons,
            httpMethod: "GET",
            completion: completion
        )
    }
}

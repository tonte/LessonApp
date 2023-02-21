import Foundation

public enum WebRequestError: Error {
    case connectionError
    case jsonDecodingError
    case generic(Error)
}

public typealias WebRequestCompletionHandler<ResultType> = ((Result<ResultType, WebRequestError>) -> ())

protocol WebRequestManagerProtocol {
    func load<T: Decodable>(
        url: URLS,
        httpMethod: String,
        completion:@ escaping WebRequestCompletionHandler<T>
    )
}

class WebRequestManager: WebRequestManagerProtocol {
    var cache: URLCache?

    init(cache: URLCache) {
        self.cache = cache
    }

    init() {
        self.cache = URLCache.shared
    }


    func load<T: Decodable> (
        url: URLS,
        httpMethod: String = "GET",
        completion:@ escaping WebRequestCompletionHandler<T>
    ) {

        guard let encodedURL = url.rawValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }

        guard let serviceUrl = URL(string: encodedURL) else { return }

        var request = URLRequest(url: serviceUrl)
        request.httpMethod = httpMethod
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        let session = URLSession(configuration: config)

        session.dataTask(with: request) { (data, response, error) in
            print(request)

            if let cachedObject = self.cache?.cachedResponse(for: request), response == nil, data == nil {
                guard let decodedJSON = try? JSONDecoder().decode(T.self, from: cachedObject.data) else {
                    let error = WebRequestError.jsonDecodingError
                    completion(.failure(error))
                    return
                }
                completion(.success(decodedJSON))
                return
            }

            if let error = error{
                completion(.failure(.generic(error)))
                return
            }
            guard let data = data else {
                let error = WebRequestError.connectionError
                completion(.failure(error))
                return
            }

            guard let decodedJSON = try? JSONDecoder().decode(T.self, from: data) else {
                let error = WebRequestError.jsonDecodingError
                completion(.failure(error))
                return
            }

            if let response = response, self.cache?.cachedResponse(for: request) == nil  {
                self.cache?.storeCachedResponse(
                    CachedURLResponse(
                        response: response,
                        data: data
                    ),
                    for: request)
            }
            
            completion(.success(decodedJSON))
        }.resume()
    }


}

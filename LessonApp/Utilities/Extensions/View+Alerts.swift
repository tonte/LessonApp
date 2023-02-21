import Foundation
import SwiftUI

struct LocalizedAlertError: LocalizedError {
    let underlyingError: WebRequestError

    var errorDescription: String? {
        switch underlyingError {
        case .connectionError, .jsonDecodingError:
            return "connection error".localizedCapitalized
        case .generic(_):
            return "error".localizedCapitalized
        }
    }
    var recoverySuggestion: String? {
        switch underlyingError {
        case .connectionError, .jsonDecodingError:
            return "Error fetching data. Please try again".localizedLowercase
        case .generic(let error):
            return error.localizedDescription
        }
    }

    init?(error: Error?) {
        guard let localizedError = error as? WebRequestError else { return nil }
        underlyingError = localizedError
    }
}


extension View {

    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK".localizedUppercase) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

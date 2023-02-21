import Foundation
import UIKit
import SwiftUI

struct LessonDetailsNavigation: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailsNavigationController


    var lesson: Lesson
    var lessons: [Lesson]


    func makeUIViewController(context: Context) -> UIViewControllerType {
        let navigationController = LessonDetailsNavigationController()
        navigationController.navigate(.details(lesson: lesson, lessons: lessons))
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class LessonDetailsNavigationController: UINavigationController {
    enum screen {
        case details(lesson: Lesson, lessons: [Lesson])

        var viewController : UIViewController {
            switch self {
            case .details (let lesson, let lessons):
                return LessonDetailsViewController(
                    viewModel: .init(
                        lesson: lesson,
                        lessons: lessons
                    )
                )
            }
        }
    }

    func navigate(_ to: screen){
        DispatchQueue.main.async {
            self.pushViewController(to.viewController, animated: true)
        }
    }
}

import Foundation
class LessonDomainModelToUiModelMapper {
    func map(_ model: Lesson) -> LessonView.UiModel {
        return .init(name: model.name, thumbnail: model.thumbnail)
    }
}

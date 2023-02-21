import Foundation
class LessonDetailsDomainToUIModelMapper {
    func map(_ model: Lesson) -> LessonDetailsView.UiModel {
        return .init(
            thumbnailUrl: model.thumbnail,
            titleLabel: model.name,
            descriptionLabel: model.description,
            videoURL: model.videoURL
        )
    }
}

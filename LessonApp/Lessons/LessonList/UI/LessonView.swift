import SwiftUI
import SDWebImageSwiftUI

struct LessonView: View {
    private let uiModel: UiModel

    init(uiModel: UiModel) {
        self.uiModel = uiModel
    }

    var body: some View {
        HStack (alignment: .center ,spacing: 20){
            WebImage(url: URL(string: uiModel.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            Text(uiModel.name)
                .font(.system(size: 16))
                .foregroundColor(Color.primary)
        }
    }

    struct UiModel {
        var name: String
        var thumbnail: String
    }
}

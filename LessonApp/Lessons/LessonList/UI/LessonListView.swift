import SwiftUI

struct LessonListView: View {
    @ObservedObject var viewModel = LessonListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.lessons, id: \.self) { item in
                NavigationLink(
                    destination: LessonDetailsNavigation(
                        lesson: item, lessons: viewModel.lessons
                    )
                    .navigationBarTitleDisplayMode(.inline)
                ) {
                    LessonView(
                        uiModel: viewModel.uiMapper.map(item)
                    )
                }
            }
            .navigationBarTitle("Lessons")
            .onAppear {
                self.viewModel.fetchLessons()
            }
        }
        .navigationViewStyle(.stack)
        .errorAlert(error: $viewModel.error)
    }
}

struct LessonListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonListView()
    }
}

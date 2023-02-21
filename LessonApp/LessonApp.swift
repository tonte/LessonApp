import SwiftUI

@main
struct LessonAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LessonListView()
        }
    }
}

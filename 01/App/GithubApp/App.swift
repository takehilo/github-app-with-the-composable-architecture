import SwiftUI
import SearchRepositoriesFeature

@main
struct GithubApp: App {
    var body: some Scene {
        WindowGroup {
            SearchRepositoriesView(store: .init(initialState: .init()) {
                SearchRepositoriesReducer()
            })
        }
    }
}

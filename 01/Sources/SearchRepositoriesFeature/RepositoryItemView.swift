import SwiftUI
import ComposableArchitecture
import Domain

struct RepositoryItemView: View {
    let store: StoreOf<RepositoryItemReducer>

    struct ViewState: Equatable {
        let name: String
        let login: String
        let description: String?
        let stars: Int

        init(state: RepositoryItemReducer.State) {
            self.name = state.name
            self.login = state.owner
            self.description = state.description
            self.stars = state.stars
        }
    }

    var body: some View {
        WithViewStore(store, observe: ViewState.init(state:)) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                Text(viewStore.name)
                    .font(.system(size: 24, weight: .bold))

                if let description = viewStore.description {
                    Text(description)
                }

                Label {
                    Text("\(viewStore.stars)")
                        .font(.system(size: 14, weight: .bold))
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                }
            }
        }
    }
}

#if DEBUG
struct RepositoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryItemView(
            store: .init(initialState: RepositoryItemReducer.State(item: .mock)) {
                RepositoryItemReducer()
            }
        )
    }
}

private extension SearchReposResponse.Item {
    static let mock: Self = .init(
        id: 1,
        name: "takehilo",
        fullName: "takehilo/github-app-with-the-composable-architecture",
        owner: .init(
            login: "takehilo",
            avatarUrl: URL(string: "https://github.com/takehilo.png")!
        ),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        stargazersCount: 1234)
}
#endif

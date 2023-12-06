import SwiftUI
import ComposableArchitecture
import RepositoryDetailFeature

public struct SearchRepositoriesView: View {
    let store: StoreOf<SearchRepositoriesReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var query: String
        @BindingViewState var showFavoritesOnly: Bool
        let hasMorePage: Bool

        init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
            self._query = store.$query
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.hasMorePage = store.hasMorePage
        }
    }

    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
                List {
                    Toggle(isOn: viewStore.$showFavoritesOnly) {
                        Text("Favorites Only")
                    }

                    ForEachStore(store.scope(
                        state: \.filteredItems,
                        action: \.items
                    )) { itemStore in
                        WithViewStore(itemStore, observe: { $0 }) { itemViewStore in
                            NavigationLink(
                                state: RepositoryDetailReducer.State(
                                    repository: itemViewStore.repository,
                                    liked: itemViewStore.liked
                                )
                            ) {
                                RepositoryItemView(store: itemStore)
                                    .onAppear {
                                        viewStore.send(.itemAppeared(id: itemStore.withState(\.id)))
                                    }
                            }
                        }
                    }

                    if viewStore.hasMorePage {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .searchable(text: viewStore.$query)
            }
        } destination: {
            RepositoryDetailView(store: $0)
        }
    }
}

#Preview {
    SearchRepositoriesView(
        store: .init(initialState: SearchRepositoriesReducer.State()) {
            SearchRepositoriesReducer()
                .dependency(
                    \.githubClient,
                     .init(searchRepos: { _, _ in .mock() })
                )
        }
    )
}

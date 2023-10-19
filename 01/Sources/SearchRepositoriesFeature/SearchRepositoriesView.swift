import SwiftUI
import ComposableArchitecture
import RepositoryDetailFeature

public struct SearchRepositoriesView: View {
    let store: StoreOf<SearchRepositoriesReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var query: String
        @BindingViewState var showFavoritesOnly: Bool
        let loadingState: SearchRepositoriesReducer.LoadingState
        let hasMorePage: Bool

        init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
            self._query = store.$query
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.loadingState = store.loadingState
            self.hasMorePage = store.hasMorePage
        }
    }

    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
                List {
                    Toggle(isOn: viewStore.$showFavoritesOnly) {
                        Text("Favorites Only")
                    }

                    ForEachStore(store.scope(
                        state: \.filteredItems,
                        action: SearchRepositoriesReducer.Action.item(id:action:)
                    )) { itemStore in
                        WithViewStore(itemStore, observe: { $0 }) { itemViewStore in
                            NavigationLink(
                                state: RepositoryDetailReducer.State(
                                    id: itemViewStore.id,
                                    name: itemViewStore.name,
                                    avatarUrl: itemViewStore.avatarUrl,
                                    description: itemViewStore.description,
                                    stars: itemViewStore.stars,
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
                        switch viewStore.loadingState {
                        case .refreshing, .loadingNext:
                            ProgressView()
                                .id(UUID())
                                .frame(maxWidth: .infinity)
                        case .none:
                            EmptyView()
                        }
                    }
                }
                .searchable(text: viewStore.$query)
            }
        } destination: {
            RepositoryDetailView(store: $0)
        }
    }
}

#if DEBUG
struct SearchRepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRepositoriesView(
            store: .init(initialState: SearchRepositoriesReducer.State()) {
                SearchRepositoriesReducer()
                    .dependency(
                        \.githubClient,
                         .init(searchRepos: { _ in .mock })
                    )
            }
        )
    }
}
#endif

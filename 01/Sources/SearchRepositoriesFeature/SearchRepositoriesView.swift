import SwiftUI
import ComposableArchitecture

public struct SearchRepositoriesView: View {
    let store: StoreOf<SearchRepositoriesReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var query: String
        let loadingState: SearchRepositoriesReducer.LoadingState
        let hasMorePage: Bool

        init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
            self._query = store.$query
            self.loadingState = store.loadingState
            self.hasMorePage = store.hasMorePage
        }
    }

    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
                List {
                    ForEachStore(store.scope(
                        state: \.items,
                        action: SearchRepositoriesReducer.Action.item(id:action:)
                    )) { itemStore in
                        RepositoryItemView(store: itemStore)
                            .onAppear {
                                viewStore.send(.itemAppeared(id: itemStore.withState(\.id)))
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

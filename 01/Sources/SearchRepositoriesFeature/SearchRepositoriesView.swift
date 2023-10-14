import SwiftUI
import ComposableArchitecture

public struct SearchRepositoriesView: View {
    let store: StoreOf<SearchRepositoriesReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var query: String

        init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
            self._query = store.$query
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
                    )) {
                        RepositoryItemView(store: $0)
                    }
                }
                .searchable(text: viewStore.$query)
                .onAppear {
                    viewStore.send(.onAppear)
                }
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
            }
        )
    }
}
#endif

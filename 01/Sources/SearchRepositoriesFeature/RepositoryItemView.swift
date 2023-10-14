import SwiftUI
import ComposableArchitecture
import Domain

struct RepositoryItemView: View {
    let store: StoreOf<RepositoryItemReducer>

    struct ViewState: Equatable {
        let name: String
        let description: String?
        let stars: Int

        init(state: RepositoryItemReducer.State) {
            self.name = state.name
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
        Form {
            RepositoryItemView(
                store: .init(initialState: RepositoryItemReducer.State(item: .mock(name: "Alice"))) {
                    RepositoryItemReducer()
                }
            )
        }
    }
}
#endif

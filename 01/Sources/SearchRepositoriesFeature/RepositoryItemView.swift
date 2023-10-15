import SwiftUI
import ComposableArchitecture
import Domain

struct RepositoryItemView: View {
    let store: StoreOf<RepositoryItemReducer>

    struct ViewState: Equatable {
        let name: String
        let stars: Int
        let liked: Bool

        init(state: RepositoryItemReducer.State) {
            self.name = state.name
            self.stars = state.stars
            self.liked = state.liked
        }
    }

    var body: some View {
        WithViewStore(store, observe: ViewState.init(state:)) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewStore.name)
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)

                    Label {
                        Text("\(viewStore.stars)")
                            .font(.system(size: 14))
                    } icon: {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.yellow)
                    }
                }

                Spacer(minLength: 16)

                Button {
                    viewStore.send(.likeTapped)
                } label: {
                    Image(systemName: viewStore.liked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.pink)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#if DEBUG
struct RepositoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            RepositoryItemView(
                store: .init(initialState: RepositoryItemReducer.State(item: .mock(id: 0, name: "Alice"))) {
                    RepositoryItemReducer()
                }
            )
        }
    }
}
#endif

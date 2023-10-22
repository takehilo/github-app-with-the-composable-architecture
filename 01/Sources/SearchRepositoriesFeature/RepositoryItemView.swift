import SwiftUI
import ComposableArchitecture
import Domain

struct RepositoryItemView: View {
    let store: StoreOf<RepositoryItemReducer>

    struct ViewState: Equatable {
        let repository: Repository
        let liked: Bool

        init(state: RepositoryItemReducer.State) {
            self.repository = state.repository
            self.liked = state.liked
        }
    }

    var body: some View {
        WithViewStore(store, observe: ViewState.init(state:)) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewStore.repository.name)
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)

                    Label {
                        Text("\(viewStore.repository.stars)")
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

#Preview {
    Form {
        RepositoryItemView(
            store: .init(initialState: RepositoryItemReducer.State(item: .mock(id: 0, name: "Alice"))) {
                RepositoryItemReducer()
            }
        )
    }
}

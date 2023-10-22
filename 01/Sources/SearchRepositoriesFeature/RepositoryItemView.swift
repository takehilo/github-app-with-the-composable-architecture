import SwiftUI
import ComposableArchitecture
import Domain

struct RepositoryItemView: View {
    let store: StoreOf<RepositoryItemReducer>

    struct ViewState: Equatable {
        let repository: Repository
        @BindingViewState var liked: Bool

        init(store: BindingViewStore<RepositoryItemReducer.State>) {
            self.repository = store.repository
            self._liked = store.$liked
        }
    }

    var body: some View {
        WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
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
                    viewStore.$liked.wrappedValue.toggle()
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

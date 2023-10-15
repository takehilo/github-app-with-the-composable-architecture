import SwiftUI
import ComposableArchitecture

public struct RepositoryDetailView: View {
    let store: StoreOf<RepositoryDetailReducer>

    struct ViewState: Equatable {
        let name: String
        let description: String?
        let avatarUrl: URL
        let stars: Int
        let liked: Bool

        init(state: RepositoryDetailReducer.State) {
            self.name = state.name
            self.avatarUrl = state.avatarUrl
            self.description = state.description
            self.stars = state.stars
            self.liked = state.liked
        }
    }

    public init(store: StoreOf<RepositoryDetailReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: ViewState.init(state:)) { viewStore in
            Form {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: viewStore.avatarUrl) { image in image.image?.resizable() }
                            .frame(width: 40, height: 40)

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

                    Spacer(minLength: 16)

                    Button {
                        viewStore.send(.likeTapped)
                    } label: {
                        Image(systemName: viewStore.liked ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.pink)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView(
            store: .init(initialState: RepositoryDetailReducer.State(
                id: 100,
                name: "takehilo",
                avatarUrl: .init(string: "https://github.com/takehilo.png")!,
                description: "",
                stars: 12345,
                liked: true
            )) {
                RepositoryDetailReducer()
            }
        )
    }
}
#endif

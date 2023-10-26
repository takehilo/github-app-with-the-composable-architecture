import SwiftUI
import ComposableArchitecture
import SharedModel

public struct RepositoryDetailView: View {
    let store: StoreOf<RepositoryDetailReducer>

    public init(store: StoreOf<RepositoryDetailReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: viewStore.repository.avatarUrl) { image in image.image?.resizable() }
                            .frame(width: 40, height: 40)

                        Text(viewStore.repository.name)
                            .font(.system(size: 24, weight: .bold))

                        if let description = viewStore.repository.description {
                            Text(description)
                        }

                        Label {
                            Text("\(viewStore.repository.stars)")
                                .font(.system(size: 14, weight: .bold))
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.yellow)
                        }
                    }

                    Spacer(minLength: 16)

                    Button {
                        viewStore.$liked.wrappedValue.toggle()
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

#Preview {
    RepositoryDetailView(
        store: .init(initialState: RepositoryDetailReducer.State(
            repository: .init(from: .mock(id: 100, name: "takehilo")),
            liked: true
        )) {
            RepositoryDetailReducer()
        }
    )
}

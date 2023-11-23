import SwiftUI
import ComposableArchitecture
import SharedModel

struct RepositoryItemView: View {
    let store: StoreOf<RepositoryItemReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
            store: .init(initialState: RepositoryItemReducer.State.make(from: .mock(id: 0, name: "Alice"))) {
                RepositoryItemReducer()
            }
        )
    }
}

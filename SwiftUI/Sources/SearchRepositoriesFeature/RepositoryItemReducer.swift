import ComposableArchitecture
import Dependencies
import SharedModel
import Foundation

@Reducer
public struct RepositoryItemReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Identifiable, Sendable {
        public var id: Int { repository.id }
        let repository: Repository
        @BindingState var liked = false

        static func make(from item: SearchReposResponse.Item) -> Self {
            .init(repository: .init(from: item))
        }
    }

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

extension IdentifiedArrayOf
where Element == RepositoryItemReducer.State, ID == Int {
    init(response: SearchReposResponse) {
        self = IdentifiedArrayOf(uniqueElements: response.items.map { .make(from: $0) })
    }
}

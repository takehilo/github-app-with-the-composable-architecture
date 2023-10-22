import ComposableArchitecture
import Dependencies
import Domain
import Foundation

public struct RepositoryItemReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Identifiable {
        public var id: Int { repository.id }
        let repository: Repository
        @BindingState var liked = false
    }

    // MARK: - Action
    public enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

extension RepositoryItemReducer.State {
    init(item: SearchReposResponse.Item) {
        self.repository = .init(from: item)
    }
}

extension IdentifiedArrayOf
where Element == RepositoryItemReducer.State, ID == Int {
    init(response: SearchReposResponse) {
        self = IdentifiedArrayOf(uniqueElements: response.items.map { .init(item: $0) })
    }
}

import ComposableArchitecture
import Dependencies
import Domain
import Foundation

public struct RepositoryItemReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Identifiable {
        public var id: Int { repository.id }
        let repository: Repository
        var liked = false
    }

    // MARK: - Action
    public enum Action: Equatable, Sendable {
        case likeTapped
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .likeTapped:
            state.liked.toggle()
            return .none
            
        }
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

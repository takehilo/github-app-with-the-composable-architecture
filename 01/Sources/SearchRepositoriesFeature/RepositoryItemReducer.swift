import ComposableArchitecture
import Dependencies
import Domain
import Foundation

public struct RepositoryItemReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Identifiable {
        public let id: UUID
        let name: String
        let description: String?
        let owner: String
        let stars: Int
        var alert: AlertState<Action>?
    }

    // MARK: - Action
    public enum Action: Equatable, Sendable {
        case onAppear
        case nameTapped
        case starTapped
        case alertDismissed
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .nameTapped:
            state.alert = AlertState(
                title: TextState("Repository name is '\(state.name)'")
            )
            return .none
        case .starTapped:
            state.alert = AlertState(
                title: TextState("\(state.stars.description) stars!!")
            )
            return .none
        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }
}

extension RepositoryItemReducer.State {
    init(item: SearchReposResponse.Item) {
        @Dependency(\.uuid) var uuid
        self.id = uuid()
        self.name = item.fullName
        self.description = item.description
        self.owner = item.owner.login
        self.stars = item.stargazersCount
    }
}

extension IdentifiedArrayOf
where Element == RepositoryItemReducer.State, ID == UUID {
    init(response: SearchReposResponse) {
        self = IdentifiedArrayOf(uniqueElements: response.items.map { .init(item: $0) })
    }
}

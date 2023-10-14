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
        let stars: Int
    }

    // MARK: - Action
    public enum Action: Equatable, Sendable {
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    }
}

extension RepositoryItemReducer.State {
    init(item: SearchReposResponse.Item) {
        @Dependency(\.uuid) var uuid
        self.id = uuid()
        self.name = item.fullName
        self.description = item.description
        self.stars = item.stargazersCount
    }
}

extension IdentifiedArrayOf
where Element == RepositoryItemReducer.State, ID == UUID {
    init(response: SearchReposResponse) {
        self = IdentifiedArrayOf(uniqueElements: response.items.map { .init(item: $0) })
    }
}

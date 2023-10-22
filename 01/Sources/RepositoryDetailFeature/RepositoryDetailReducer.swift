import ComposableArchitecture
import Dependencies
import Foundation
import Domain

public struct RepositoryDetailReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable {
        public var id: Int { repository.id }
        public let repository: Repository
        public var liked: Bool

        public init(
            repository: Repository,
            liked: Bool
        ) {
            self.repository = repository
            self.liked = liked
        }
    }

    public init() {}

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

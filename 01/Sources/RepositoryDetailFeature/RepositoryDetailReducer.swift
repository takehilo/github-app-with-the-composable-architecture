import ComposableArchitecture
import Dependencies
import Foundation

public struct RepositoryDetailReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable {
        public let id: Int
        public let name: String
        public let avatarUrl: URL
        public let description: String?
        public let stars: Int
        public var liked: Bool

        public init(
            id: Int,
            name: String,
            avatarUrl: URL,
            description: String?,
            stars: Int,
            liked: Bool
        ) {
            self.id = id
            self.name = name
            self.avatarUrl = avatarUrl
            self.description = description
            self.stars = stars
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

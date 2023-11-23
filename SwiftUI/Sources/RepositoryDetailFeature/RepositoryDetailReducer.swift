import ComposableArchitecture
import Dependencies
import Foundation
import SharedModel

@Reducer
public struct RepositoryDetailReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Sendable {
        public var id: Int { repository.id }
        public let repository: Repository
        @BindingState public var liked = false

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
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

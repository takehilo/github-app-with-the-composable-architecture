import ComposableArchitecture
import Dependencies
import GithubClient
import Domain

public struct SearchRepositoriesReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable {
        var items = IdentifiedArrayOf<RepositoryItemReducer.State>()
        @BindingState var query = ""
        var currentPage = 1

        public init() {}
    }

    private enum CancelId { case searchRepos }

    // MARK: - Action
    public enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case item(id: Int, action: RepositoryItemReducer.Action)
        case onAppear
        case searchReposResponse(TaskResult<SearchReposResponse>)
    }

    // MARK: - Dependencies
    @Dependency(\.githubClient) var githubClient
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {

            case .onAppear:
                return .none

            case .binding(\.$query):
                guard !state.query.isEmpty else { return .cancel(id: CancelId.searchRepos) }
                return .run { [query = state.query, page = state.currentPage] send in
                    await send(.searchReposResponse(TaskResult {
                        try await githubClient.searchRepos(.init(query: query, page: page))
                    }))
                }
                .debounce(id: CancelId.searchRepos, for: 0.3, scheduler: mainQueue)

            case .binding:
                return .none

            case let .searchReposResponse(.success(response)):
                state.items = .init(response: response)
                return .none

            case .searchReposResponse(.failure):
                return .none

            case .item:
                return .none

            }
        }
    }
}

import ComposableArchitecture
import Dependencies
import GithubClient
import SharedModel
import Foundation
import RepositoryDetailFeature

@Reducer
public struct SearchRepositoriesReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Sendable {
        var items = IdentifiedArrayOf<RepositoryItemReducer.State>()
        @BindingState var query = ""
        @BindingState var showFavoritesOnly = false
        var currentPage = 1
        var loadingState: LoadingState = .refreshing
        var hasMorePage = false
        var path = StackState<RepositoryDetailReducer.State>()

        var filteredItems: IdentifiedArrayOf<RepositoryItemReducer.State> {
            items.filter {
                !showFavoritesOnly || $0.liked
            }
        }

        public init() {}
    }

    enum LoadingState: Equatable {
        case refreshing
        case loadingNext
        case none
    }

    private enum CancelId { case searchRepos }

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case items(IdentifiedActionOf<RepositoryItemReducer>)
        case itemAppeared(id: Int)
        case searchReposResponse(Result<SearchReposResponse, Error>)
        case path(StackAction<RepositoryDetailReducer.State, RepositoryDetailReducer.Action>)
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

            case .binding(\.$query):
                guard !state.query.isEmpty else {
                    state.hasMorePage = false
                    state.items.removeAll()
                    return .cancel(id: CancelId.searchRepos)
                }

                state.currentPage = 1
                state.loadingState = .refreshing

                return .run { [query = state.query, page = state.currentPage] send in
                    await send(.searchReposResponse(Result {
                        try await githubClient.searchRepos(query: query, page: page)
                    }))
                }
                .debounce(id: CancelId.searchRepos, for: 0.3, scheduler: mainQueue)

            case .binding:
                return .none

            case let .searchReposResponse(.success(response)):
                switch state.loadingState {
                case .refreshing:
                    state.items = .init(response: response)
                case .loadingNext:
                    let newItems = IdentifiedArrayOf(response: response)
                    state.items.append(contentsOf: newItems)
                case .none:
                    break
                }

                state.hasMorePage = response.totalCount > state.items.count
                state.loadingState = .none
                return .none

            case .searchReposResponse(.failure):
                return .none

            case let .itemAppeared(id: id):
                if state.hasMorePage, state.items.index(id: id) == state.items.count - 1 {
                    state.currentPage += 1
                    state.loadingState = .loadingNext

                    return .run { [query = state.query, page = state.currentPage] send in
                        await send(.searchReposResponse(Result {
                            try await githubClient.searchRepos(query: query, page: page)
                        }))
                    }
                } else {
                    return .none
                }

            case .items:
                return .none

            case let .path(.element(id: id, action: .binding(\.$liked))):
                guard let repositoryDetail = state.path[id: id] else { return .none }
                state.items[id: repositoryDetail.id]?.liked = repositoryDetail.liked
                return .none

            case .path:
                return .none

            }
        }
        .forEach(\.items, action: \.items) {
            RepositoryItemReducer()
        }
        .forEach(\.path, action: \.path) {
            RepositoryDetailReducer()
        }
    }
}

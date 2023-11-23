import XCTest
import ComposableArchitecture
import SharedModel
import RepositoryDetailFeature

@testable import SearchRepositoriesFeature

@MainActor
class SearchRepositoriesFeatureTests: XCTestCase {
    func testSearchRepositories() async {
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: SearchRepositoriesReducer.State()) {
            SearchRepositoriesReducer()
        } withDependencies: {
            $0.githubClient.searchRepos = { @Sendable _, _ in .mock(totalCount: 10) }
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }

        await store.send(.set(\.$query, "t")) {
            $0.query = "t"
            $0.currentPage = 1
            $0.loadingState = .refreshing
        }

        await mainQueue.advance(by: .seconds(0.1))

        await store.send(.set(\.$query, "tca")) {
            $0.query = "tca"
            $0.currentPage = 1
            $0.loadingState = .refreshing
        }

        await mainQueue.advance(by: .seconds(0.3))

        await store.receive(\.searchReposResponse.success) {
            $0.items = .init(response: .mock(totalCount: 10))
            $0.hasMorePage = true
            $0.loadingState = .none
        }

        await store.send(.set(\.$query, "")) {
            $0.query = ""
            $0.hasMorePage = false
            $0.items = []
        }
    }

    func testPagination() async {
        var initialState = SearchRepositoriesReducer.State()
        initialState.items = .init(response: .mock())
        initialState.hasMorePage = true
        
        let store = TestStore(initialState: initialState) {
            SearchRepositoriesReducer()
        } withDependencies: {
            $0.githubClient.searchRepos = { @Sendable _, _ in .mock2(totalCount: 10) }
        }

        await store.send(.itemAppeared(id: 4)) {
            $0.currentPage = 2
            $0.loadingState = .loadingNext
        }

        await store.receive(\.searchReposResponse.success) {
            $0.items = .init(response: .mockAll())
            $0.hasMorePage = false
            $0.loadingState = .none
        }
    }

    func testSyncLikes() async {
        var initialState = SearchRepositoriesReducer.State()
        initialState.path = StackState([
            RepositoryDetailReducer.State(repository: .init(from: .mock(id: 1, name: "Alice")), liked: false)
        ])

        let store = TestStore(initialState: initialState) {
            SearchRepositoriesReducer()
        }
        store.exhaustivity = .off

        await store.send(.path(.element(id: 0, action: .set(\.$liked, true)))) {
            $0.items[id: 0]?.liked = true
        }
    }
}

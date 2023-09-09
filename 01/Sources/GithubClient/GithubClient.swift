import Dependencies
import Domain

public struct GithubClient: Sendable {
    public var searchRepos: @Sendable (SearchReposParams) async throws -> SearchReposResponse

    public init(searchRepos: @Sendable @escaping (SearchReposParams) async throws -> SearchReposResponse) {
        self.searchRepos = searchRepos
    }

    public struct SearchReposParams: Equatable {
        public let query: String
        public let page: Int

        public init(
            query: String,
            page: Int
        ) {
            self.query = query
            self.page = page
        }
    }
}

extension GithubClient: TestDependencyKey {
    public static let testValue: GithubClient = .init(
        searchRepos: unimplemented("\(Self.self).searchRepos")
    )

    public static let previewValue: GithubClient = .init(
        searchRepos: unimplemented("\(Self.self).searchRepos")
    )
}

public extension DependencyValues {
    var githubClient: GithubClient {
        get { self[GithubClient.self] }
        set { self[GithubClient.self] = newValue }
    }
}

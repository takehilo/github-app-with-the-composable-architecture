import APIKit
import SharedModel

struct SearchReposRequest: GithubRequest {
    typealias Response = SearchReposResponse
    let method = APIKit.HTTPMethod.get
    let path = "/search/repositories"
    let queryParameters: [String: Any]?

    public init(
        query: String,
        page: Int
    ) {
        self.queryParameters = [
            "q": query,
            "page": page.description,
            "per_page": 10
        ]
    }
}

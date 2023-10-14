#if DEBUG
import Foundation

public extension SearchReposResponse {
    static var mock: Self {
        .init(
            totalCount: 10,
            items: [
                .mock(name: "Alice"),
                .mock(name: "Bob"),
                .mock(name: "Carol"),
                .mock(name: "Dave"),
                .mock(name: "Ellen"),
            ]
        )
    }
}

public extension SearchReposResponse.Item {
    static func mock(name: String) -> Self {
        .init(
            name: name,
            fullName: "\(name)/awesome-repository",
            owner: .init(
                login: name,
                avatarUrl: URL(string: "https://github.com/\(name).png")!
            ),
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
            stargazersCount: Int.random(in: 10..<10000)
        )
    }
}
#endif

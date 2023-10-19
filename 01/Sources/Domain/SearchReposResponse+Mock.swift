#if DEBUG
import Foundation

public extension SearchReposResponse {
    static var mock: Self {
        .init(
            totalCount: 5,
            items: [
                .mock(id: 0, name: "Alice"),
                .mock(id: 1, name: "Bob"),
                .mock(id: 2, name: "Carol"),
                .mock(id: 3, name: "Dave"),
                .mock(id: 4, name: "Ellen"),
            ]
        )
    }
}

public extension SearchReposResponse.Item {
    static func mock(id: Int, name: String) -> Self {
        .init(
            id: id,
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

#if DEBUG
import Foundation

public extension SearchReposResponse {
    static func mock(totalCount: Int = 5) -> Self {
        .init(
            totalCount: totalCount,
            items: [
                .mock(id: 0, name: "Alice"),
                .mock(id: 1, name: "Bob"),
                .mock(id: 2, name: "Carol"),
                .mock(id: 3, name: "Dave"),
                .mock(id: 4, name: "Ellen"),
            ]
        )
    }

    static func mock2(totalCount: Int = 5) -> Self {
        .init(
            totalCount: totalCount,
            items: [
                .mock(id: 5, name: "Frank"),
                .mock(id: 6, name: "George"),
                .mock(id: 7, name: "Harry"),
                .mock(id: 8, name: "Ivan"),
                .mock(id: 9, name: "Justin")
            ]
        )
    }

    static func mockAll() -> Self {
        .init(
            totalCount: 10,
            items: [
                .mock(id: 0, name: "Alice"),
                .mock(id: 1, name: "Bob"),
                .mock(id: 2, name: "Carol"),
                .mock(id: 3, name: "Dave"),
                .mock(id: 4, name: "Ellen"),
                .mock(id: 5, name: "Frank"),
                .mock(id: 6, name: "George"),
                .mock(id: 7, name: "Harry"),
                .mock(id: 8, name: "Ivan"),
                .mock(id: 9, name: "Justin")
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
            stargazersCount: id * 100
        )
    }
}
#endif

import Foundation

public struct Repository: Equatable, Sendable {
    public let id: Int
    public let name: String
    public let avatarUrl: URL
    public let description: String?
    public let stars: Int
}

public extension Repository {
    init (from item: SearchReposResponse.Item) {
        self.id = item.id
        self.name = item.fullName
        self.avatarUrl = item.owner.avatarUrl
        self.description = item.description
        self.stars = item.stargazersCount
    }
}

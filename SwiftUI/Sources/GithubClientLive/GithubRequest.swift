import Foundation
import APIKit
import ApiClient

protocol GithubRequest: BaseRequest {
}

extension GithubRequest {
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var headerFields: [String: String] { baseHeaders }
    var decoder: JSONDecoder { JSONDecoder() }

    var baseHeaders: [String: String] {
        var params: [String: String] = [:]
        params["Accept"] = "application/vnd.github+json"
        params["Authorization"] = "Bearer <TOKEN>"
        return params
    }
}

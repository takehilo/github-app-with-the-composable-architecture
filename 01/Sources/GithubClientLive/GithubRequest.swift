import Foundation
import APIKit

protocol GithubRequest: BaseRequest {
}

extension GithubRequest {
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var headerFields: [String: String] { baseHeaders }
    var decoder: JSONDecoder { JSONDecoder() }

    var baseHeaders: [String: String] {
        var params: [String: String] = [:]
        params["Accept"] = "application/vnd.github.v3+json"
        return params
    }
}
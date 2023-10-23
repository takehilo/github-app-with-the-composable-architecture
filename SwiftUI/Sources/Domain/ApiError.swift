import Foundation

public enum ApiError: Error, Equatable {
    case unacceptableStatusCode(Int)
    case unknown(NSError)
}

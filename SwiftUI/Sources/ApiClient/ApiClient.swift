import Foundation
import SharedModel
@preconcurrency import APIKit

public final class ApiClient: Sendable {
    private let session: Session

    public init(session: Session) {
        self.session = session
    }

    public func send<T: BaseRequest>(request: T) async throws -> T.Response {
        do {
            return try await session.response(for: request)
        } catch let originalError as SessionTaskError {
            switch originalError  {
            case let .connectionError(error), let .responseError(error), let .requestError(error):
                throw ApiError.unknown(error as NSError)
            case let .responseError(error as ApiError):
                throw error
            }
        }
    }

    public static let liveValue = ApiClient(session: Session.shared)
    public static let testValue = ApiClient(session: Session(adapter: NoopSessionAdapter()))
}

public final class NoopSessionTask: SessionTask {
    public func resume() {}
    public func cancel() {}
}

public struct NoopSessionAdapter: SessionAdapter {
    public func createTask(
        with URLRequest: URLRequest,
        handler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> SessionTask {
        return NoopSessionTask()
    }

    public func getTasks(with handler: @escaping ([SessionTask]) -> Void) {
        handler([])
    }
}

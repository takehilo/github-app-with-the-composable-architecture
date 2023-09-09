import Foundation
@preconcurrency import APIKit
import Domain

struct ApiClient: Sendable {
    private let session: Session

    init(session: Session) {
        self.session = session
    }

    func send<T: BaseRequest>(request: T) async throws -> T.Response {
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

final class NoopSessionTask: SessionTask {
    func resume() {}
    func cancel() {}
}

struct NoopSessionAdapter: SessionAdapter {
    func createTask(
        with URLRequest: URLRequest,
        handler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> SessionTask {
        return NoopSessionTask()
    }

    func getTasks(with handler: @escaping ([SessionTask]) -> Void) {
        handler([])
    }
}

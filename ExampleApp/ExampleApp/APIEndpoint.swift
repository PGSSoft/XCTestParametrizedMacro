import Foundation

enum APIEndpoint {
    case order(String)
    case transactions
    case profile

    var buildURL: URL? {
        switch self {
        case .order(let id):
            return URL(string: "https://example.com/api/order/\(id)")
        case .profile:
            return URL(string: "https://example.com/api/me")
        case .transactions:
                        return URL(string: "https://example.com/api/transactions")
        }
    }
}

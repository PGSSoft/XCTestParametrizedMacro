import XCTest
import XCTestParametrizedMacro

final class APIEndpointsTests: XCTestCase {

    @Parametrize(
        input: [APIEndpoint.profile, APIEndpoint.transactions, APIEndpoint.order("2345")],
        output: ["https://example.com/api/me",
                 "https://example.com/api/transactions",
                 "https://example.com/api/order/2345"],
        labels: ["profile",
                 "transactions",
                 "order"])
    func testEndpointURL(input endpoint: APIEndpoint, output expectedUrl: String) throws {
        XCTAssertEqual(endpoint.buildURL?.absoluteString, expectedUrl)
    }
}

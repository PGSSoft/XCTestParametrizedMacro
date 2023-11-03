import XCTest
import XCTestParametrizedMacro

final class APIEndpointsTests: XCTestCase {

    @Parametrize(input: [APIEndpoint.profile, APIEndpoint.transactions, APIEndpoint.order("2345")])
    func testEndpointURL(input endpoint: APIEndpoint) throws {
        XCTAssertNotNil(endpoint.buildURL)
    }
}

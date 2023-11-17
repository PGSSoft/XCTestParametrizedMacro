import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import XCTestParametrizedMacroMacros

final class LabelsParameterTests: XCTestCase {

    let testMacros: [String: Macro.Type] = [
        "Parametrize": ParametrizeMacro.self,
    ]

    func testParametrizeInputLabels_OneLabel() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [3.1415], labels: ["Pi"])
                func testValidateDouble(input n: Double) throws {
                    XCTAssertNotNil(validate_number(n))
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testValidateDouble(input n: Double) throws {
                    XCTAssertNotNil(validate_number(n))
                }

                func testValidateDouble_Pi() throws {
                    let n: Double = 3.1415
                    XCTAssertNotNil(validate_number(n))
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInputOutputLabels_OneLabel() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [3], output: [9], labels: ["ThreePowerOfTheTwo"])
                func testPow2(input n: Int, output result: Int) {
                    XCTAssertEqual(pow2(n),result)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testPow2(input n: Int, output result: Int) {
                    XCTAssertEqual(pow2(n),result)
                }

                func testPow2_ThreePowerOfTheTwo() {
                    let n: Int = 3
                    let result: Int = 9
                    XCTAssertEqual(pow2(n), result)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInputOutputLabels_TwoLabels() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [3, 4], output: [9, 16], labels: ["ThreePowerOfTheTwo", "FourPowerOfTheTwo"])
                func testPow2(input n: Int, output result: Int) {
                    XCTAssertEqual(pow2(n),result)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testPow2(input n: Int, output result: Int) {
                    XCTAssertEqual(pow2(n),result)
                }

                func testPow2_ThreePowerOfTheTwo() {
                    let n: Int = 3
                    let result: Int = 9
                    XCTAssertEqual(pow2(n), result)
                }

                func testPow2_FourPowerOfTheTwo() {
                    let n: Int = 4
                    let result: Int = 16
                    XCTAssertEqual(pow2(n), result)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInputOutputLabels_CustomObjects() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
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
            """,
            expandedSource: """
            struct TestStruct {
                func testEndpointURL(input endpoint: APIEndpoint, output expectedUrl: String) throws {
                    XCTAssertEqual(endpoint.buildURL?.absoluteString, expectedUrl)
                }

                func testEndpointURL_profile() throws {
                    let endpoint: APIEndpoint = APIEndpoint.profile
                    let expectedUrl: String = "https://example.com/api/me"
                    XCTAssertEqual(endpoint.buildURL?.absoluteString, expectedUrl)
                }

                func testEndpointURL_transactions() throws {
                    let endpoint: APIEndpoint = APIEndpoint.transactions
                    let expectedUrl: String =
                                     "https://example.com/api/transactions"
                    XCTAssertEqual(endpoint.buildURL?.absoluteString, expectedUrl)
                }

                func testEndpointURL_order() throws {
                    let endpoint: APIEndpoint = APIEndpoint.order("2345")
                    let expectedUrl: String =
                                     "https://example.com/api/order/2345"
                    XCTAssertEqual(endpoint.buildURL?.absoluteString, expectedUrl)
                }
            }
            """,
            macros: testMacros
        )
    }
}



import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import XCTestParametrizedMacroMacros

final class InputOutputParametersTests: XCTestCase {

    let testMacros: [String: Macro.Type] = [
        "Parametrize": ParametrizeMacro.self,
    ]

    func testParametrizeInputOutput_SingleInts() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [3], output: [9])
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

                func testPow2_N_3_Result_9() {
                    let n: Int = 3
                    let result: Int = 9
                    XCTAssertEqual(pow2(n), result)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInputOutput_TwoInts() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [4, 5], output: [16, 25])
                func testPow2(input n: Int, output result: Int) throws {
                    XCTAssertEqual(pow2(n),result)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testPow2(input n: Int, output result: Int) throws {
                    XCTAssertEqual(pow2(n),result)
                }

                func testPow2_N_4_Result_16() throws {
                    let n: Int = 4
                    let result: Int = 16
                    XCTAssertEqual(pow2(n), result)
                }

                func testPow2_N_5_Result_25() throws {
                    let n: Int = 5
                    let result: Int = 25
                    XCTAssertEqual(pow2(n), result)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInputOutput_TwoStringsTwoInts() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: ["Swift", "SwiftMacro"], output: [5, 10])
                func testWordLength(input word: String, output length: Int) {
                    XCTAssertEqual(word.count, length)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testWordLength(input word: String, output length: Int) {
                    XCTAssertEqual(word.count, length)
                }

                func testWordLength_Word_Swift_Length_5() {
                    let word: String = "Swift"
                    let length: Int = 5
                    XCTAssertEqual(word.count, length)
                }

                func testWordLength_Word_SwiftMacro_Length_10() {
                    let word: String = "SwiftMacro"
                    let length: Int = 10
                    XCTAssertEqual(word.count, length)
                }
            }
            """,
            macros: testMacros
        )
    }
}

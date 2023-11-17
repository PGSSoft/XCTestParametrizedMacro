import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import XCTestParametrizedMacroMacros

final class EffectSpecifiersTests: XCTestCase {

    let testMacros: [String: Macro.Type] = [
        "Parametrize": ParametrizeMacro.self,
    ]

    func testWithInputNoSpecifiers() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1])
                func testMethod(input n: Int) {
                    XCTAssertTrue(n>0)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testMethod(input n: Int) {
                    XCTAssertTrue(n>0)
                }

                func testMethod_N_1() {
                    let n: Int = 1
                    XCTAssertTrue(n > 0)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testWithInputAsyncAndThrows() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1])
                func testMethod(input n: Int) async throws {
                    XCTAssertTrue(n>0)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testMethod(input n: Int) async throws {
                    XCTAssertTrue(n>0)
                }

                func testMethod_N_1() async throws {
                    let n: Int = 1
                    XCTAssertTrue(n > 0)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testWithInputAsync() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1])
                func testMethod(input n: Int) async {
                    XCTAssertTrue(n>0)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testMethod(input n: Int) async {
                    XCTAssertTrue(n>0)
                }

                func testMethod_N_1() async {
                    let n: Int = 1
                    XCTAssertTrue(n > 0)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testWithInputOutputNoSpecifiers() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1], output: [1])
                func testMethod(input n: Int, output r: Int) {
                    XCTAssertEqual(n,r)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testMethod(input n: Int, output r: Int) {
                    XCTAssertEqual(n,r)
                }

                func testMethod_N_1_R_1() {
                    let n: Int = 1
                    let r: Int = 1
                    XCTAssertEqual(n, r)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testWithInputOutputAsync() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1], output: [1])
                func testMethod(input n: Int, output r: Int) async {
                    XCTAssertEqual(n,r)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testMethod(input n: Int, output r: Int) async {
                    XCTAssertEqual(n,r)
                }

                func testMethod_N_1_R_1() async {
                    let n: Int = 1
                    let r: Int = 1
                    XCTAssertEqual(n, r)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testWithInputOutputLabelsAsyncThrows() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1], output: [1], labels: ["One"])
                func testMethod(input n: Int, output r: Int) async throws {
                    XCTAssertEqual(n,r)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testMethod(input n: Int, output r: Int) async throws {
                    XCTAssertEqual(n,r)
                }

                func testMethod_One() async throws {
                    let n: Int = 1
                    let r: Int = 1
                    XCTAssertEqual(n, r)
                }
            }
            """,
            macros: testMacros
        )
    }
}

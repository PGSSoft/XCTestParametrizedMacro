import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import XCTestParametrizedMacroMacros

final class AttachmentTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Parametrize": ParametrizeMacro.self,
    ]

    func testParametrizeInput_AttachToStruct_ShouldFail() throws {
        assertMacroExpansion(
            """
            @Parametrize(input: ["Natasha"])
            struct TestStruct {
            }
            """,
            expandedSource: """
            struct TestStruct {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Parametrize macro can be used only for functions.", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInput_AttachToEnum_ShouldFail() throws {
        assertMacroExpansion(
            """
            @Parametrize(input: ["Natasha"])
            enum TestEnum {
            }
            """,
            expandedSource: """
            enum TestEnum {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Parametrize macro can be used only for functions.", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInput_AttachToClass_ShouldFail() throws {
        assertMacroExpansion(
            """
            @Parametrize(input: ["Natasha"])
            class TestClass {
            }
            """,
            expandedSource: """
            class TestClass {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Parametrize macro can be used only for functions.", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInput_AttachToMethodWithoutInputSecondName_ShouldFail() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: ["Natasha"])
                func testDataModel(input: String) throws {
                    let model = DataModel(name: input)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input: String) throws {
                    let model = DataModel(name: input)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Input parameter must have a second name. Something like `testMethod(input secondName: String)`.", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInput_AttachToMethodWithoutBody_ShouldFail() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: ["Natasha"])
                func testDataModel(input name: String) throws {
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input name: String) throws {
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Function must have a body.", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInput_MacroWithoutAttributes_ShouldFail() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize()
                func testDataModel(input name: String) throws {
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input name: String) throws {
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Parametrize macro requires at least one attribute as array of input/output values.", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInput_MacroWithoutArrayAttribute_ShouldFail() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: "Natasha")
                func testDataModel(input name: String) throws {
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input name: String) throws {
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Parametrize macro requires at least one attribute as array of input/output values.", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }

    func testParametrizeInputOutput_DifferentSizeOfArrays_ShouldFail() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [1,2,3], output: [1,4])
                func testPow2(input n: Int, output result: Int) {
                    XCTAssertEqual(pow2(n), result)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testPow2(input n: Int, output result: Int) {
                    XCTAssertEqual(pow2(n), result)
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Size of the input array and output array should be the same.", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }
}

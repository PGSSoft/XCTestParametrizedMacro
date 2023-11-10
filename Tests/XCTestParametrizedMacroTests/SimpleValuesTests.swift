import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import XCTestParametrizedMacroMacros

final class SimpleValuesTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Parametrize": ParametrizeMacro.self,
    ]

    func testParametrizeInput_SingleStringValue() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: ["Natasha"])
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

                func testDataModel_Name_Natasha() throws {
                    let name: String = "Natasha"
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_TwoStringValues() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: ["Natasha", "Alexandra"])
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

                func testDataModel_Name_Natasha() throws {
                    let name: String = "Natasha"
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }

                func testDataModel_Name_Alexandra() throws {
                    let name: String = "Alexandra"
                    let model = DataModel(name: name)
                    XCTAssertTrue(model.isFemale())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_SingleIntValue() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [20])
                func testDataModel(input age: Int) throws {
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input age: Int) throws {
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }

                func testDataModel_Age_20() throws {
                    let age: Int = 20
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_TwoIntValues() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [20, 30])
                func testDataModel(input age: Int) throws {
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input age: Int) throws {
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }

                func testDataModel_Age_20() throws {
                    let age: Int = 20
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }
            
                func testDataModel_Age_30() throws {
                    let age: Int = 30
                    let model = DataModel(age: age)
                    XCTAssertTrue(model.isAdult())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_SingleBoolValue() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [true])
                func testDataModel(input isAuthorized: Bool) throws {
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input isAuthorized: Bool) throws {
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }

                func testDataModel_IsAuthorized_true() throws {
                    let isAuthorized: Bool = true
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_TwoBoolValues() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [true, false])
                func testDataModel(input isAuthorized: Bool) throws {
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input isAuthorized: Bool) throws {
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }

                func testDataModel_IsAuthorized_true() throws {
                    let isAuthorized: Bool = true
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }
            
                func testDataModel_IsAuthorized_false() throws {
                    let isAuthorized: Bool = false
                    let model = DataModel(isAuthorized: isAuthorized)
                    XCTAssertTrue(model.isAuthorizationRequired())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_OneObject() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [Foo()])
                func testDataModel(input object: Foo) throws {
                    let model = DataModel(object: object)
                    XCTAssertTrue(model.isValid())
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input object: Foo) throws {
                    let model = DataModel(object: object)
                    XCTAssertTrue(model.isValid())
                }

                func testDataModel_Object_Foo__() throws {
                    let object: Foo = Foo()
                    let model = DataModel(object: object)
                    XCTAssertTrue(model.isValid())
                }
            }
            """,
            macros: testMacros
        )
    }

    func testParametrizeInput_FewObjects() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @Parametrize(input: [Foo.first, .second, .init(rawValue: 3)!])
                func testDataModel(input object: Foo) throws {
                    let dataModel = DataModel(object)
                    XCTAssertTrue(dataModel.isValid)
                }
            }
            """,
            expandedSource: """
            struct TestStruct {
                func testDataModel(input object: Foo) throws {
                    let dataModel = DataModel(object)
                    XCTAssertTrue(dataModel.isValid)
                }

                func testDataModel_Object_Foo_first() throws {
                    let object: Foo = Foo.first
                    let dataModel = DataModel(object)
                    XCTAssertTrue(dataModel.isValid)
                }

                func testDataModel_Object__second() throws {
                    let object: Foo = .second
                    let dataModel = DataModel(object)
                    XCTAssertTrue(dataModel.isValid)
                }

                func testDataModel_Object__init_rawValue__3__() throws {
                    let object: Foo = .init(rawValue: 3)!
                    let dataModel = DataModel(object)
                    XCTAssertTrue(dataModel.isValid)
                }
            }
            """,
            macros: testMacros
        )
    }

}

import SwiftSyntaxMacros
import XCTest

@testable import XCTestParametrizedMacroMacros

final class ParamValueTransformerTests: XCTestCase {

    func testTransform() throws {
        XCTAssertEqual(ParamValueTransformer.transform(value: "Simple"), "Simple")
        XCTAssertEqual(ParamValueTransformer.transform(value: "A/B Tests"), "A_B_Tests")
        XCTAssertEqual(ParamValueTransformer.transform(value: "3.14"), "3_14")
    }

    func testTransformInts() throws {
        XCTAssertEqual(ParamValueTransformer.transform(value: "999"), "999")
        XCTAssertEqual(ParamValueTransformer.transform(value: "123_000_000"), "123_000_000")
    }

    func testTransformCustomObjects() throws {
        XCTAssertEqual(ParamValueTransformer.transform(value: "Foo()"), "Foo__")
        XCTAssertEqual(ParamValueTransformer.transform(value: ".first"), "_first")
        XCTAssertEqual(ParamValueTransformer.transform(value: "Foo.init(rawValue: 1)!"), "Foo_init_rawValue__1__")
    }

}

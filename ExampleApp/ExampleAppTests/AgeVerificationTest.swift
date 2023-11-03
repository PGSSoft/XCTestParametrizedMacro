import XCTest
import XCTestParametrizedMacro

final class AgeVerificationTest: XCTestCase {

    @Parametrize(input: [18, 25, 45, 99])
    func testAgeValidatorValidAge(input age: Int) throws {
        XCTAssertTrue(AgeValidator.isAdult(age: age))
    }

    @Parametrize(input: [2, 5, 17])
    func testAgeValidatorInvalidAge(input age: Int) throws {
        XCTAssertFalse(AgeValidator.isAdult(age: age))
    }



}

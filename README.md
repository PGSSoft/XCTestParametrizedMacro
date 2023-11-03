# XCTestParametrizedMacro
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift Version"></a>
<a href="https://github.com/PGSSoft/XCTestParametrizedMacro/blob/main/LICENSE"><img src="https://img.shields.io/github/license/pgssoft/xctestparametrizedmacro.svg" alt="License"></a>
## Summary

A straightforward yet powerful Swift macro designed to simplify the unit test creation process. This tool allows you to easily parameterize your XCTest methods by automatically generating test methods based on specified arguments. Write your test method once and effortlessly generate variations with different parameters. This approach not only simplifies test maintenance but also makes identifying failing tests more effective. Inspired by JUnit parametrized tests.

## Requirements

Xcode 15 or above
Swift 5.9 or later

## Installation

**Xcode project**

If you are using Xcode open `File -> Add Package Dependencies...` and enter url `https://github.com/pgssoft/XCTestParametrizedMacro`

**Swift package manager**

In `Package.swift` add:

``` swift
dependencies: [
  .package(url: "https://github.com/pgssoft/XCTestParametrizedMacro", branch: "main")
]
```

and then add the product to your test target.

```swift
.product(name: "XCTestParametrizedMacro", package: "XCTestParametrizedMacro"),
```

and import it in your unit test file

```swift
import XCTestParametrizedMacro
```

## Examples

Let's consider a simple example. You want to implement unit tests for the method validating the age of the user.
```swift
struct AgeValidator {
    static func isAdult(age: Int) -> Bool {
        age >= 18
    }
}
```

If you want to test it for a few values you can write two generic methods and use macro to create a separate test method for each value.
```swift
    @Parametrize(input: [18, 25, 99])
    func testAgeValidatorValidAge(input age: Int) throws {
        XCTAssertTrue(AgeValidator.isAdult(age: age))
    }

    @Parametrize(input: [2, 17])
    func testAgeValidatorInvalidAge(input age: Int) throws {
        XCTAssertFalse(AgeValidator.isAdult(age: age))
    }
```

Macro will generate a test method for every case.

```swift
    func testAgeValidatorValidAge_Age_18() throws {
        let age: Int = 18
        XCTAssertTrue(AgeValidator.isAdult(age: age))
    }

    func testAgeValidatorValidAge_Age_25() throws {
        let age: Int = 25
        XCTAssertTrue(AgeValidator.isAdult(age: age))
    }

    func testAgeValidatorValidAge_Age_99() throws {
        let age: Int = 99
        XCTAssertTrue(AgeValidator.isAdult(age: age))
    }

    func testAgeValidatorInvalidAge_Age_2() throws {
        let age: Int = 2
        XCTAssertFalse(AgeValidator.isAdult(age: age))
    }

    func testAgeValidatorInvalidAge_Age_17() throws {
        let age: Int = 17
        XCTAssertFalse(AgeValidator.isAdult(age: age))
    }
```

But as an input parameter, you can use custom types as well.

```swift
    @Parametrize(input: [APIEndpoint.profile, APIEndpoint.transactions, APIEndpoint.order("2345")])
    func testEndpointURL(input endpoint: APIEndpoint) throws {
        XCTAssertNotNil(endpoint.buildURL)
    }
```

The macro will generate the following test methods.

```swift
    func testEndpointURL_Endpoint_APIEndpoint_profile() throws {
        let endpoint: APIEndpoint = APIEndpoint.profile
        XCTAssertNotNil(endpoint.buildURL)
    }

    func testEndpointURL_Endpoint_APIEndpoint_transactions() throws {
        let endpoint: APIEndpoint = APIEndpoint.transactions
        XCTAssertNotNil(endpoint.buildURL)
    }

    func testEndpointURL_Endpoint_APIEndpoint_order_2345_() throws {
        let endpoint: APIEndpoint = APIEndpoint.order("2345")
        XCTAssertNotNil(endpoint.buildURL)
    }
```

## Features

- [x] Primitive types as input values (like Int, Double, String and Bool)
- [x] Custom objects as input values (like structs, classes and enums)
- [x] Diagnostics for error handling
- [ ] Expected output array of objects/values
- [ ] Labels for paramter values like: `@Parametrize(input: [3.14, 2.71], labels: ["pi", "e"])`

## License
XCTestParametrizedMacro is released under an MIT license. See [LICENSE](LICENSE)

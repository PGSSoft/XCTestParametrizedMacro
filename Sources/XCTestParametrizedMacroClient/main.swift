import XCTestParametrizedMacro
import XCTest

enum Foo: Int {
    case first = 1
    case second = 2
    case third = 3
}

func pow2(_ n: Int) -> Int {
    n*n
}

class Test {
    @Parametrize(input: [Foo.first, .second, .init(rawValue: 3)!])
    func test_sample(input object: Foo) {
        print(object.rawValue)
    }

    @Parametrize(input: [1,2,3], output: [1,4,9])
    func testPow2(input n: Int, output result: Int) {
        print("\(n) => \(result)")
    }

    @Parametrize(input: ["Swift","SwiftMacro"], output: [5, 10])
    func testWordLength(input word: String, output length: Int) {
        XCTAssertEqual(word.count, length)
    }
}

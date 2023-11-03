import XCTestParametrizedMacro

enum Foo: Int {
    case first = 1
    case second = 2
    case third = 3
}

class Test {
    @Parametrize(input: [Foo.first, .second, .init(rawValue: 3)!])
    func test_sample(input object: Foo) {
        print(object.rawValue)
    }
}

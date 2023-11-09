@attached(peer, names: arbitrary)
public macro Parametrize<T>(input: [T]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

@attached(peer, names: arbitrary)
public macro Parametrize<I, O>(input: [I], output: [O]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

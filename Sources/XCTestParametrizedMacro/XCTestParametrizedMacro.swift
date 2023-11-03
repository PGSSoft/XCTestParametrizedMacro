@attached(peer, names: arbitrary)
public macro Parametrize<T>(input: [T]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

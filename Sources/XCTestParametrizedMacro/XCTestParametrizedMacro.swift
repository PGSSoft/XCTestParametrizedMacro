@attached(peer, names: arbitrary)
public macro Parametrize<I>(input: [I]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

@attached(peer, names: arbitrary)
public macro Parametrize<I>(input: [I], labels: [String]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

@attached(peer, names: arbitrary)
public macro Parametrize<I, O>(input: [I], output: [O]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

@attached(peer, names: arbitrary)
public macro Parametrize<I, O>(input: [I], output: [O], labels: [String]) = #externalMacro(module: "XCTestParametrizedMacroMacros", type: "ParametrizeMacro")

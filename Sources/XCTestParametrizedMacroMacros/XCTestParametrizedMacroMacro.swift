import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct ParametrizeMacro: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {

        guard let declaration = declaration.as(FunctionDeclSyntax.self) else {
            throw ParametrizeMacroError.notAttachedToAFunction
        }

        let macroDeclarationHelper = MacroDeclarationHelper(declaration)

        return try TestMethodsFactory(macroDeclarationHelper: macroDeclarationHelper).create()
    }
}

extension ArrayElementSyntax {

    /// returns content as string representation that can be used in function name
    var asFunctionName: String {
        let value = self.expression.description
        return ParamValueTransformer.transform(value: value)
    }
}

@main
struct XCTestParametrizedMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ParametrizeMacro.self,
    ]
}

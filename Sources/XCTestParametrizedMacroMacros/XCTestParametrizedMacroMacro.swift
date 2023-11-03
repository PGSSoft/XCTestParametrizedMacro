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

        let funcName = declaration.identifier
        guard let inputParamName = declaration.signature.input.parameterList.first?.secondName?.text else {
            throw ParametrizeMacroError.functionInputParamSecondNameMissing
        }

        guard let inputParamType = declaration.signature.input.parameterList.first?.type else {
            throw ParametrizeMacroError.functionInputParamTypeMissing
        }

        guard let codeStatements = declaration.body?.statements, codeStatements.count > 0 else {
            throw ParametrizeMacroError.functionBodyEmpty
        }

        let textCode = codeStatements.map { "\($0.trimmed)" }.joined(separator: "\n")
        return try macroDeclarationHelper.inputValues.map {
                        """
                        func \(funcName)_\(raw: inputParamName.capitalizedFirst)_\(raw: $0.asFunctionName)() throws {
                        let \(raw: inputParamName):\(raw: inputParamType) = \($0.expression)
                        \(raw: textCode)
                        }
                        """
        }
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

import Foundation
import SwiftSyntax

struct MacroDeclarationHelper {
    let declaration: FunctionDeclSyntax

    init(_ declaration: FunctionDeclSyntax) {
        self.declaration = declaration
    }

    var firstAttribute: AttributeSyntax? {
        return declaration.attributes.first?.as(AttributeSyntax.self)
    }

    var inputValues: ArrayElementListSyntax {
        get throws {
            guard let firstMacroArgument = firstAttribute?.argument?.as(TupleExprElementListSyntax.self) else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            guard let arrayOfValues = firstMacroArgument.first?.as(TupleExprElementSyntax.self)?.expression.as(ArrayExprSyntax.self)?.elements else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            return arrayOfValues
        }
    }

}

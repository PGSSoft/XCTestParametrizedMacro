import Foundation
import SwiftSyntax

struct MacroDeclarationHelper {
    let declaration: FunctionDeclSyntax

    init(_ declaration: FunctionDeclSyntax) {
        self.declaration = declaration
    }


    /// Returns 'TokenSyntax' representing name of the input parameter.
    var inputParamName: TokenSyntax? {
        declaration.signature.input.parameterList.first?.secondName
    }
    
    /// Returns 'TypeSyntax' representing type of the input object.
    var inputParamType: TypeSyntax? {
        declaration.signature.input.parameterList.first?.type
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

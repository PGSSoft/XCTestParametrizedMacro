import Foundation
import SwiftSyntax

struct MacroDeclarationHelper {
    let declaration: FunctionDeclSyntax

    init(_ declaration: FunctionDeclSyntax) {
        self.declaration = declaration
    }

    var funcName: TokenSyntax {
        declaration.name
    }

    var funcStatements: CodeBlockItemListSyntax? {
        declaration.body?.statements
    }

    /// Returns 'TokenSyntax' representing name of the input parameter.
    var inputParamName: TokenSyntax? {
        declaration.signature.parameterClause.parameters.first?.secondName
    }
    
    /// Returns 'TypeSyntax' representing type of the input object.
    var inputParamType: TypeSyntax? {
        declaration.signature.parameterClause.parameters.first?.type
    }

    /// Returns 'TokenSyntax' representing name of the output parameter.
    var outputParamName: TokenSyntax? {
        declaration.signature.parameterClause.parameters.last?.secondName
    }

    /// Returns 'TokenSyntax' representing type of the output object.
    var outputParamType: TypeSyntax? {
        declaration.signature.parameterClause.parameters.last?.type
    }

    var firstAttribute: AttributeSyntax? {
        return declaration.attributes.first?.as(AttributeSyntax.self)
    }

    var inputValues: ArrayElementListSyntax {
        get throws {
            guard let firstMacroArgument = firstAttribute?.arguments?.as(LabeledExprListSyntax.self) else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            guard let arrayOfValues = firstMacroArgument.first?.as(LabeledExprSyntax.self)?.expression.as(ArrayExprSyntax.self)?.elements else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            return arrayOfValues
        }
    }

    var outputValues: ArrayElementListSyntax? {
        get throws {
            guard let firstMacroArgument = firstAttribute?.arguments?.as(LabeledExprListSyntax.self) else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }
            
            guard let outputArgument = firstMacroArgument.first(where: { $0.label?.text == "output" }) else {
                return nil
            }

            guard let arrayOfValues = outputArgument.as(LabeledExprSyntax.self)?.expression.as(ArrayExprSyntax.self)?.elements else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            return arrayOfValues
        }
    }

    var labels: ArrayElementListSyntax? {
        get throws {
            guard let firstMacroArgument = firstAttribute?.arguments?.as(LabeledExprListSyntax.self) else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            guard let labelsArgument = firstMacroArgument.first(where: { $0.label?.text == "labels" }) else {
                return nil
            }

            guard let arrayOfValues = labelsArgument.as(LabeledExprSyntax.self)?.expression.as(ArrayExprSyntax.self)?.elements else {
                throw ParametrizeMacroError.macroAttributeNotAnArray
            }

            return arrayOfValues
        }
    }
}

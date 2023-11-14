import Foundation
import SwiftSyntax

struct TestMethodsFactory {

    let macroDeclarationHelper: MacroDeclarationHelper

    var bodyFunc: String {
        get throws {
            guard let codeStatements = macroDeclarationHelper.funcStatements, codeStatements.count > 0 else {
                throw ParametrizeMacroError.functionBodyEmpty
            }
            return codeStatements.map { "\($0.trimmed)" }.joined(separator: "\n")
        }
    }

    func create() throws -> [DeclSyntax] {

        let funcName = macroDeclarationHelper.funcName

        guard let inputParamName = macroDeclarationHelper.inputParamName?.text else {
            throw ParametrizeMacroError.functionInputParamSecondNameMissing
        }

        guard let inputParamType =  macroDeclarationHelper.inputParamType else {
            throw ParametrizeMacroError.functionInputParamTypeMissing
        }

        let outputParamName = macroDeclarationHelper.outputParamName?.text
        let outputParamType = macroDeclarationHelper.outputParamType

        let input = try macroDeclarationHelper.inputValues.map { $0 }
        let output: [ArrayElementListSyntax.Element?] = try macroDeclarationHelper.outputValues?.map { $0 } ?? .init(repeating: nil, count: input.count)
        let labels: [ArrayElementListSyntax.Element?] = try macroDeclarationHelper.labels?.map { $0 } ?? .init(repeating: nil, count: input.count)

        guard input.count == output.count, output.count == labels.count else {
            throw ParametrizeMacroError.macroAttributeArraysMismatchSize
        }
        return try zip(input, zip(output, labels)).map { (input, arg) in
            let (output, label) = arg
            return """
                \(raw: buildTestMethodSignature(funcName: funcName, inputParamName: inputParamName, inputObject: input, outputParamName: outputParamName, outputObject: output, label: label))
                \(raw: buildLocalVariables(inputParamName: inputParamName,
                inputParamType: inputParamType,
                inputObject: input,
                outputParamName: outputParamName,
                outputParamType: outputParamType,
                outputObject: output))
                \(raw: try bodyFunc)
                }
                """
        }

    }

    func buildTestMethodSignature(funcName: TokenSyntax,
                                  inputParamName: String,
                                  inputObject: ArrayElementListSyntax.Element,
                                  outputParamName: String? = nil,
                                  outputObject: ArrayElementListSyntax.Element? = nil,
                                  label: ArrayElementListSyntax.Element? = nil ) -> String {
        guard label == nil else {
            return "func \(funcName)_\(label!.asFunctionName)() throws {"
        }
        if let outputParamName = outputParamName, let outputObject = outputObject {
            return "func \(funcName)_\(inputParamName.capitalizedFirst)_\(inputObject.asFunctionName)_\(outputParamName.capitalizedFirst)_\(outputObject.asFunctionName)() throws {"
        } else {
            return "func \(funcName)_\(inputParamName.capitalizedFirst)_\(inputObject.asFunctionName)() throws {"
        }
    }

    func buildLocalVariables(inputParamName: String,
                             inputParamType: TypeSyntax,
                             inputObject: ArrayElementListSyntax.Element,
                             outputParamName: String? = nil,
                             outputParamType: TypeSyntax? = nil,
                             outputObject: ArrayElementListSyntax.Element? = nil) -> String {
        var decl = "let \(inputParamName):\(inputParamType) = \(inputObject.expression)"
        if let outputParamName = outputParamName,
           let outputParamType = outputParamType,
           let outputObject = outputObject {
            decl.append("\n")
            decl.append("let \(outputParamName):\(outputParamType) = \(outputObject.expression)")
        }
        return decl
    }
}

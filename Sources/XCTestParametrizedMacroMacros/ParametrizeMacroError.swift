import Foundation

enum ParametrizeMacroError: Error, CustomStringConvertible {
    case notAttachedToAFunction
    case functionInputParamSecondNameMissing
    case functionInputParamTypeMissing
    case functionBodyEmpty
    case macroAttributeNotAnArray
    case macroAttributeMismatchSizeInputOutputArray

    var description: String {
        switch self {
        case .notAttachedToAFunction:
            return "Parametrize macro can be used only for functions."
        case .functionInputParamSecondNameMissing:
            return "Input parameter must have a second name. Something like `testMethod(input secondName: String)`."
        case .functionInputParamTypeMissing:
            return "Input parameter must have a type."
        case .functionBodyEmpty:
            return "Function must have a body."
        case .macroAttributeNotAnArray:
            return "Parametrize macro requires at least one attribute as array of input values."
        case .macroAttributeMismatchSizeInputOutputArray:
            return "Size of the input array and output array should be the same."
        }
    }
}

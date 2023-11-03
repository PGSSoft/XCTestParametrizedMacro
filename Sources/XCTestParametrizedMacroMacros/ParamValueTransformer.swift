import Foundation

struct ParamValueTransformer {
    static func transform(value: String?) -> String {
        guard let value = value else {
            return ""
        }
        let val = value
            .replacingOccurrences(of: "\"", with: "")
            .map { ($0.isLetter || $0.isNumber) ? $0 : "_"}
        return String(val)
    }
}

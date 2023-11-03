import Foundation

extension String {

    /// Returns string with uppercased only first letter.
    var capitalizedFirst: String {
        let firstLetter =  self.prefix(1).localizedCapitalized
        return firstLetter + String(self.dropFirst(1))
    }
}

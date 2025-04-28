import SwiftUI

struct AppColor {
    static let primaryRed = Color(red: 230/255, green: 4/255, blue: 73/255)
    static let cardLightGray = Color(red: 240/255, green: 240/255, blue: 240/255)
    static let dividerGray = Color.gray.opacity(0.2)
    static let shadowColor = Color.black.opacity(0.1)
    static let defaultText = Color.black
    static let secondaryText = Color.gray
    
    // Add missing color properties that are used in components
    static let text = Color.black
    static let card = Color(red: 240/255, green: 240/255, blue: 240/255)
    static let shadow = Color.black.opacity(0.1)
    static let divider = Color.gray.opacity(0.2)
    static let background = Color.white
}

//
//  AppColor.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//


import SwiftUI

struct AppColor {
    static let primaryRed     = Color(hex: "#E6014A")  // Bold red color
    static let textFieldGray  = Color(hex: "#F6F6F6")  // Light gray color
    static let defaultText    = Color.black            // Default text color
}

extension Color {
    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >> 8) & 0xFF) / 255
        b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

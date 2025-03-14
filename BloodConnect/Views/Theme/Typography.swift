//
//  Typography.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI

struct Typography {
    // Heading styles
    static let largeTitle = Font.system(size: 34, weight: .bold)
    static let title = Font.system(size: 28, weight: .bold)
    static let title2 = Font.system(size: 22, weight: .bold)
    static let title3 = Font.system(size: 20, weight: .semibold)
    
    // Body styles
    static let body = Font.system(size: 17, weight: .regular)
    static let bodyBold = Font.system(size: 17, weight: .semibold)
    
    // Button styles
    static let buttonText = Font.system(size: 16, weight: .semibold)
    
    // Caption styles
    static let caption = Font.system(size: 14, weight: .regular)
    static let captionBold = Font.system(size: 14, weight: .medium)
    
    // Small text
    static let footnote = Font.system(size: 12, weight: .regular)
}

//
//  SocialLoginButton..swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI

struct SocialLoginButton: View {
    enum SocialProvider {
        case google
        case apple
        case facebook
        
        var title: String {
            switch self {
            case .google: return "Sign in with Google"
            case .apple: return "Sign in with Apple"
            case .facebook: return "Sign in with Facebook"
            }
        }
        
        var iconName: String {
            switch self {
            case .google: return "google-logo" // Add to assets
            case .apple: return "apple.logo"
            case .facebook: return "facebook-logo" // Add to assets
            }
        }
        
        var isSystemImage: Bool {
            switch self {
            case .apple: return true
            default: return false
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .google, .apple: return .white
            case .facebook: return Color(hex: "#1877F2")
            }
        }
        
        var textColor: Color {
            switch self {
            case .google, .apple: return .black
            case .facebook: return .white
            }
        }
    }
    
    let provider: SocialProvider
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                // Provider logo
                if provider.isSystemImage {
                    Image(systemName: provider.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(provider == .apple ? (colorScheme == .dark ? .white : .black) : provider.textColor)
                        .padding(.leading, 8)
                } else if provider == .google {
                    GoogleLogoView()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 8)
                } else {
                    Image(provider.iconName)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 8)
                }
                
                Text(provider.title)
                    .font(Typography.buttonText)
                    .foregroundColor(provider.textColor)
                
                Spacer()
            }
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(provider == .apple && colorScheme == .dark ? Color.black : provider.backgroundColor)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// SVG-based Google logo
struct GoogleLogoView: View {
    var body: some View {
        ZStack {
            // Blue part
            Path { path in
                path.move(to: CGPoint(x: 36, y: 24.55))
                path.addLine(to: CGPoint(x: 36, y: 20))
                path.addLine(to: CGPoint(x: 24, y: 20))
                path.addLine(to: CGPoint(x: 24, y: 29.02))
                path.addLine(to: CGPoint(x: 36.94, y: 29.02))
                path.addCurve(to: CGPoint(x: 32.16, y: 36.2), control1: CGPoint(x: 36.36, y: 31.98), control2: CGPoint(x: 34.68, y: 34.5))
                path.addLine(to: CGPoint(x: 39.89, y: 42.2))
                path.addCurve(to: CGPoint(x: 46.98, y: 24.55), control1: CGPoint(x: 44.4, y: 38.02), control2: CGPoint(x: 46.98, y: 31.84))
            }
            .fill(Color(red: 66/255, green: 133/255, blue: 244/255))
            
            // Green part
            Path { path in
                path.move(to: CGPoint(x: 24, y: 48))
                path.addCurve(to: CGPoint(x: 39.89, y: 42.19), control1: CGPoint(x: 30.48, y: 48), control2: CGPoint(x: 35.93, y: 45.87))
                path.addLine(to: CGPoint(x: 32.16, y: 36.19))
                path.addCurve(to: CGPoint(x: 24, y: 38.49), control1: CGPoint(x: 30.01, y: 37.64), control2: CGPoint(x: 27.24, y: 38.49))
                path.addCurve(to: CGPoint(x: 10.53, y: 28.58), control1: CGPoint(x: 17.74, y: 38.49), control2: CGPoint(x: 12.43, y: 34.27))
                path.addLine(to: CGPoint(x: 2.55, y: 34.77))
                path.addCurve(to: CGPoint(x: 24, y: 48), control1: CGPoint(x: 6.51, y: 42.62), control2: CGPoint(x: 14.62, y: 48))
            }
            .fill(Color(red: 52/255, green: 168/255, blue: 83/255))
            
            // Yellow part
            Path { path in
                path.move(to: CGPoint(x: 2.55, y: 13.23))
                path.addLine(to: CGPoint(x: 10.53, y: 19.42))
                path.addCurve(to: CGPoint(x: 24, y: 9.5), control1: CGPoint(x: 12.43, y: 13.72), control2: CGPoint(x: 17.74, y: 9.5))
                path.addCurve(to: CGPoint(x: 33.21, y: 13.1), control1: CGPoint(x: 27.54, y: 9.5), control2: CGPoint(x: 30.71, y: 10.72))
                path.addLine(to: CGPoint(x: 40.06, y: 6.25))
                path.addCurve(to: CGPoint(x: 24, y: 0), control1: CGPoint(x: 35.9, y: 2.38), control2: CGPoint(x: 30.47, y: 0))
                path.addCurve(to: CGPoint(x: 2.55, y: 13.23), control1: CGPoint(x: 14.62, y: 0), control2: CGPoint(x: 6.51, y: 5.38))
            }
            .fill(Color(red: 251/255, green: 188/255, blue: 5/255))
            
            // Red part
            Path { path in
                path.move(to: CGPoint(x: 2.55, y: 34.77))
                path.addLine(to: CGPoint(x: 10.53, y: 28.58))
                path.addCurve(to: CGPoint(x: 10.53, y: 19.42), control1: CGPoint(x: 9.57, y: 25.69), control2: CGPoint(x: 9.57, y: 22.31))
                path.addLine(to: CGPoint(x: 2.55, y: 13.23))
                path.addCurve(to: CGPoint(x: 2.55, y: 34.77), control1: CGPoint(x: 0.92, y: 19.77), control2: CGPoint(x: 0.92, y: 28.23))
            }
            .fill(Color(red: 234/255, green: 67/255, blue: 53/255))
        }
        .scaleEffect(0.4)
    }
}

#Preview {
    VStack(spacing: 20) {
        SocialLoginButton(provider: .google) {}
        SocialLoginButton(provider: .apple) {}
        SocialLoginButton(provider: .facebook) {}
    }
    .padding()
}

//
//  SplashScreenView.swift
//  BloodConnect
//
//  Created by Student on 17/04/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
            ZStack {
                // Background Color
                AppColor.primaryRed
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()

                    // Logo
                    Image(systemName: "drop.fill")
                                      .font(.system(size: 150))
                                      .foregroundColor(.white)
                    // Text
                    Text("BloodConnect")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()
                }
            }
        }
    }

#Preview {
    SplashScreenView()
}

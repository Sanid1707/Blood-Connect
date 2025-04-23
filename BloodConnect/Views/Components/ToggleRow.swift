//
//  ToggleRow.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct ToggleRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Circle()
                .fill(AppColor.primaryRed)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: icon).foregroundColor(.white))
            Text(title)
                .foregroundColor(AppColor.defaultText)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppColor.primaryRed)
            
        }
        .padding()
        .background(AppColor.cardLightGray)
        .cornerRadius(10)
    }
}

struct ToggleRow_Previews: PreviewProvider {
    @State static var isOn = true

    static var previews: some View {
        ToggleRow(icon: "heart.circle.fill", title: "I Want To Donate", isOn: $isOn)
            .previewLayout(.sizeThatFits)
            .padding()
    
    }
}

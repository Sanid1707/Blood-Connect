//
//  ProfileActionView.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct ProfileActionRow: View {
    var icon: String
    var title: String
    var action: () -> Void = {} 

    var body: some View {
        Button(action: action){
        HStack {
            Circle()
                .fill(AppColor.primaryRed)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: icon).foregroundColor(.white))
            Text(title)
                .foregroundColor(AppColor.text)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppColor.secondaryText)
        }
        .padding()
        .background(AppColor.card)
        .cornerRadius(10)
    }
}
}

struct ProfileActionRow_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionRow(icon: "gearshape.fill", title: "Settings")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


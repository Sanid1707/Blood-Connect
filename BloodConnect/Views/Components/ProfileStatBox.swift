//
//  StatBox.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct ProfileStatBox: View{
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(AppColor.secondaryText)
            Text(value)
                .font(.title3)
                .bold()
        }
        .frame(width: 100, height: 60)
        .background(AppColor.cardLightGray)
        .cornerRadius(10)
    }
}


struct ProfileStatBox_Previews: PreviewProvider {
    static var previews: some View {
        StatBox(title: "Donations", value: "05")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

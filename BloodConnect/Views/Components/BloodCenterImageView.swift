//
//  BloodCenterImageView.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct BloodCenterImageView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 400)
            .clipped()
            .overlay(
                HStack {
                    Image(systemName: "arrow.left")
                        .padding()
                        .foregroundColor(.black)
                    Spacer()
                },
                alignment: .topLeading
            )
    }
}
struct BloodCenterImageView_Previews: PreviewProvider {
    static var previews: some View {
        BloodCenterImageView(imageName: "BloodCenter")
            .previewLayout(.sizeThatFits)
    }
}

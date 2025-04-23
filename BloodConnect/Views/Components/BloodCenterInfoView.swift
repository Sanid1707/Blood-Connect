//
//  BloodCenterInfoView.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct BloodCenterInfoView: View {
    var name: String
    var location: String
    var rating: String
    var description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                    Text(rating)
                        .font(.subheadline)
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.red)
                Text(location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

struct BloodCenterInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BloodCenterInfoView(
            name: "Cork Blood Center",
            location: "Cork",
            rating: "3.5",
            description: "A blood donation facility centered at the heart of Cork"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


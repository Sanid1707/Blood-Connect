import SwiftUI

struct BloodSeekerCardView: View {
    let name: String
    let description: String
    let timeAgo: String
    let location: String
    let bloodType: String
    let imageURL: String
    let onDonate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(AppColor.cardLightGray)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(AppColor.secondaryText)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColor.defaultText)
                    
                    Text(timeAgo)
                        .font(.system(size: 12))
                        .foregroundColor(AppColor.secondaryText)
                }
                
                Spacer()
                
                Text(bloodType)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColor.primaryRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(AppColor.secondaryText)
                .lineLimit(2)
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(AppColor.secondaryText)
                    Text(location)
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.secondaryText)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white)
                )
                
                Spacer()
                
                Button(action: onDonate) {
                    HStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 12))
                        Text("Donate")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColor.primaryRed)
                    .cornerRadius(20)
                }
            }
        }
        .padding(16)
        .background(AppColor.cardLightGray)
        .cornerRadius(16)
        .shadow(color: AppColor.shadowColor, radius: 8, x: 0, y: 2)
    }
}

struct BloodSeekerCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    BloodSeekerCardView(
                        name: "James Peterson",
                        description: "Lorem ipsum is simply dummy text of the printing and typesetting industry.",
                        timeAgo: "5 Min Ago",
                        location: "London, England",
                        bloodType: "B+",
                        imageURL: "https://example.com/image.jpg"
                    ) {
                        print("Donate tapped")
                    }
                    
                    BloodSeekerCardView(
                        name: "Sarah Johnson",
                        description: "Urgently need blood donation for surgery scheduled tomorrow morning.",
                        timeAgo: "30 Min Ago",
                        location: "Manchester, UK",
                        bloodType: "O-",
                        imageURL: "https://example.com/image.jpg"
                    ) {
                        print("Donate tapped")
                    }
                }
                .padding()
            }
        }
    }
} 
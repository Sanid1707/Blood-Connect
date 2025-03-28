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
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(timeAgo)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(bloodType)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.red)
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.gray)
                Text(location)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: onDonate) {
                    Text("Donate")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct BloodSeekerCardView_Previews: PreviewProvider {
    static var previews: some View {
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
        .padding()
        .background(Color.gray.opacity(0.1))
    }
} 
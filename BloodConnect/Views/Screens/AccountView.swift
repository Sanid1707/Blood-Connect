import SwiftUI

struct AccountView: View {
    @State private var wantsToDonate = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 8) {
                    Image("Person")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle()) // Optional for rounded avatar
                        .foregroundColor(AppColor.secondaryText)

                    Text("Lilian Jack")
                        .font(.title3).bold()
                    Text("Last Donation: October, 2023")
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                }
                .padding(.top)

                // Stats
                HStack(spacing: 16) {
                    ProfileStatBox(title: "Donations", value: "05")
                    ProfileStatBox(title: "Requests", value: "03")
                    ProfileStatBox(title: "Life Saved", value: "06")
                }

                // Options List
                VStack(spacing: 12) {
                    ToggleRow(
                        icon: "heart.circle.fill",
                        title: "I Want To Donate",
                        isOn: $wantsToDonate
                    )

                    ProfileActionRow(icon: "pencil.circle.fill", title: "Edit Profile")
                    ProfileActionRow(icon: "hands.sparkles.fill", title: "Blood Request")
                    ProfileActionRow(icon: "gearshape.fill", title: "Settings")
                    ProfileActionRow(icon: "person.2.fill", title: "Invite Friends")
                    ProfileActionRow(icon: "doc.text.fill", title: "Privacy Policy")
                    ProfileActionRow(icon: "star.fill", title: "Rate Us")
                    ProfileActionRow(icon: "info.circle.fill", title: "About Us")
                }

                // Sign Out
                Button(action: {
                    // sign out logic here
                }) {
                    HStack {
                        Image(systemName: "arrow.backward.circle.fill")
                        Text("Sign Out")
                            .bold()
                    }
                    .foregroundColor(AppColor.primaryRed)
                    .padding()
                }
            }
            .padding()
        }
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

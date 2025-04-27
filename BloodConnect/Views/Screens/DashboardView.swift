import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    @State private var isLoaded = false
    @State private var showFindDonorsView = false
    @State private var showDonateView = false
    @State private var showMapScreen = false
    @State private var showBloodRequestView = false
    @State private var users: [User] = []

    let actions = [
        ("drop.fill", "Find Donors", AppColor.primaryRed),
        ("heart.fill", "Donate", AppColor.primaryRed),
        ("cross.case.fill", "Blood Bank", AppColor.primaryRed),
        ("hand.raised.fill", "Support", AppColor.primaryRed),
        ("exclamationmark.triangle.fill", "Blood Req.", AppColor.primaryRed),
        ("ellipsis", "More", AppColor.primaryRed)
    ]

    let bloodSeekers = [
        (name: "James Peterson", desc: "I am anaemic and urgently need blood today.please reach out.Transportation and Feeding can be provided.", time: "5 Min Ago", location: "London, England", bloodType: "B+", imageURL: "https://randomuser.me/api/portraits/men/23.jpg"),
        (name: "Sarah Johnson", desc: "Urgently need blood donation for surgery scheduled tomorrow morning.", time: "30 Min Ago", location: "Manchester, UK", bloodType: "O-", imageURL: "https://randomuser.me/api/portraits/women/45.jpg"),
        (name: "Robert Williams", desc: "Need blood for emergency transfusion at City Hospital.", time: "1 Hour Ago", location: "Birmingham, UK", bloodType: "A+", imageURL: "https://randomuser.me/api/portraits/men/76.jpg")
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TopBarView(
                    title: "Blood Connect",
                    showBackButton: false,
                    onSettingsTapped: {}
                )

                ScrollView {
                    VStack(spacing: 20) {
                        SearchBarView(searchText: $searchText)
                            .padding(.top, 15)

                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .overlay(
                                    Text("Live map preview")
                                        .foregroundColor(.gray)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(AppColor.dividerGray, lineWidth: 1)
                                )
                                .frame(height: 180)
                                .padding(.horizontal)

                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        showMapScreen = true
                                    }) {
                                        Image(systemName: "paperplane.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(AppColor.primaryRed)
                                            .clipShape(Circle())
                                    }
                                    .padding(.trailing, 25)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                        .fullScreenCover(isPresented: $showMapScreen) {
                            NearbyMapView()
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                            ForEach(Array(zip(actions.indices, actions)), id: \ .0) { index, actionItem in
                                let (icon, title, color) = actionItem

                                ActionButtonView(icon: icon, title: title) {
                                    handleActionButtonTap(index: index)
                                }
                                .opacity(isLoaded ? 1.0 : 0)
                                .animation(
                                    Animation.easeIn(duration: 0.3).delay(0.2),
                                    value: isLoaded
                                )
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Blood Seeker")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColor.defaultText)

                                Spacer()

                                Button("See All") {}
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColor.primaryRed)
                            }
                            .padding(.horizontal)

                            ForEach(bloodSeekers, id: \ .name) { seeker in
                                BloodSeekerCardView(
                                    name: seeker.name,
                                    seekerDescription: seeker.desc,
                                    timeAgo: seeker.time,
                                    location: seeker.location,
                                    bloodType: seeker.bloodType,
                                    imageURL: seeker.imageURL,
                                    onDonate: {
                                        print("Donate tapped for \(seeker.name)")
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
            .background(Color.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isLoaded = true
                    }
                }
            }

            NavigationLink(destination: FindDonorsView(), isActive: $showFindDonorsView) { EmptyView() }
            NavigationLink(destination: DonateView(), isActive: $showDonateView) { EmptyView() }
            NavigationLink(destination: PostBloodRequestView(), isActive: $showBloodRequestView) { EmptyView() }
        }
    }

    private func handleActionButtonTap(index: Int) {
        switch index {
        case 0:
            showFindDonorsView = true
        case 1:
            showDonateView = true
        case 2:
            print("Blood Bank tapped")
        case 3:
            print("Support tapped")
        case 4:
            showBloodRequestView = true
        case 5:
            print("More tapped")
        default:
            break
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

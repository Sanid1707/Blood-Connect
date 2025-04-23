import SwiftUI


struct InboxView: View {
    @State private var searchText = ""

    let messages: [Message] = [
        Message(name: "Michel Lucas", time: "9:31", unread: true),
        Message(name: "Liam Elijah", time: "9:31", unread: true),
        Message(name: "Daniel Henry", time: "9:31"),
        Message(name: "Benjamin Jack", time: "9:31"),
        Message(name: "Archer Noah", time: "9:31"),
        Message(name: "Oliver James", time: "9:31"),
        Message(name: "Luke Gariel", time: "9:31"),
        Message(name: "Thomas Carter", time: "9:31")
    ]

    var body: some View {
        VStack(spacing: 10) {
            // Header
        
            TopBarView(
                title: "Inbox",
                showBackButton: true,
                onBackTapped: {
            
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            .padding(.horizontal)

            // Search bar with filter button
            SearchBarView(searchText: $searchText)

            // Messages list
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(messages, id: \.name) { message in
                        MessageRow(message: message)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

       
        }
    }
}


struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
} 

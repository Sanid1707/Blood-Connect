import Foundation

struct BloodSeeker: Identifiable {
    let id = UUID()
    let name: String
    let seekerDescription: String
    let timeAgo: String
    let location: String
    let bloodType: String
    let imageURL: String
    
    // Sample data for previews
    static let samples = [
        BloodSeeker(
            name: "James Peterson",
            seekerDescription: "Lorem ipsum is simply dummy text of the printing and typesetting industry.",
            timeAgo: "5 Min Ago",
            location: "London, England",
            bloodType: "B+",
            imageURL: "https://example.com/image.jpg"
        ),
        BloodSeeker(
            name: "Sarah Johnson",
            seekerDescription: "Urgently need blood donation for surgery scheduled tomorrow morning.",
            timeAgo: "30 Min Ago",
            location: "Manchester, UK",
            bloodType: "O-",
            imageURL: "https://example.com/image2.jpg"
        ),
        BloodSeeker(
            name: "Robert Williams",
            seekerDescription: "Need blood for emergency transfusion at City Hospital.",
            timeAgo: "1 Hour Ago",
            location: "Birmingham, UK",
            bloodType: "A+",
            imageURL: "https://example.com/image3.jpg"
        )
    ]
} 
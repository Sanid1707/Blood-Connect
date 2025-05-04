# 🩸 BloodConnect

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Firebase](https://img.shields.io/badge/Firebase-9.0+-yellow.svg)](https://firebase.google.com)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0+-red.svg)](https://developer.apple.com/xcode/swiftui/)

A revolutionary iOS application that bridges the gap between blood donors and recipients, leveraging modern technology to make blood donation more accessible, efficient, and life-saving.

## 📱 User Interface Walkthrough

| Feature | Screenshot | Description |
|---------|------------|-------------|
| **Donor Registration** | <img src="BloodConnect/Views/Resources/images/Singup%20page%20for%20Donors.png" width="250" style="border-radius: 10px;"> | **Purpose**: Register as a blood donor<br><br>**Features**:<br>- Personal information collection<br>- Blood type specification<br>- Medical history questionnaire<br>- Location-based registration<br>- Automatic address detection from EIR code |
| **Center Registration** | <img src="BloodConnect/Views/Resources/images/sign%20up%20for%20donation%20centers.png" width="250" style="border-radius: 10px;"> | **Purpose**: Register as a blood donation center<br><br>**Features**:<br>- Organization details<br>- Center location verification<br>- Operating hours setup<br>- Capacity management<br>- Automatic location verification |
| **Login Experience** | <img src="BloodConnect/Views/Resources/images/LoginPage.png" width="250" style="border-radius: 10px;"> | **Features**:<br>- Secure authentication<br>- Role-based access<br>- Remember me functionality<br>- Password recovery<br>- Biometric authentication support |
| **Main Dashboard** | <img src="BloodConnect/Views/Resources/images/Dashboard%20Page.png" width="250" style="border-radius: 10px;"> | **Key Features**:<br>- Quick access to all main functions<br>- Real-time notifications<br>- Recent activity feed<br>- Emergency requests highlight<br>- Location-based suggestions |
| **Blood Request Creation** | <img src="BloodConnect/Views/Resources/images/requestblood.png" width="250" style="border-radius: 10px;"> | **Purpose**: Create blood donation requests<br><br>**Features**:<br>- Set blood type requirements<br>- Define search radius<br>- Add urgency level<br>- Include patient details<br>- Automatic geo-fencing<br>- Firebase synchronization |
| **Donor Search** | <img src="BloodConnect/Views/Resources/images/FindDonorPage.png" width="250" style="border-radius: 10px;"> | **Features**:<br>- Advanced search filters<br>- Location-based matching<br>- Blood type compatibility<br>- Availability status<br>- Contact information |
| **Donor Profile** | <img src="BloodConnect/Views/Resources/images/FindDonorProfile.png" width="250" style="border-radius: 10px;"> | **Information Displayed**:<br>- Blood type<br>- Donation history<br>- Availability status<br>- Location<br>- Contact details<br>- Rating and reviews |
| **Donation Management** | <img src="BloodConnect/Views/Resources/images/DonatePage.png" width="250" style="border-radius: 10px;"> | **Features**:<br>- Schedule donations<br>- Track donation history<br>- View upcoming appointments<br>- Manage availability<br>- Receive reminders |
| **Communication** | <img src="BloodConnect/Views/Resources/images/inboxPage.png" width="250" style="border-radius: 10px;"> | **Features**:<br>- Direct messaging<br>- Appointment confirmations<br>- Emergency alerts<br>- System notifications<br>- Message history |
| **Notifications** | <img src="BloodConnect/Views/Resources/images/NotificationPage.png" width="250" style="border-radius: 10px;"> | **Types of Notifications**:<br>- Emergency requests<br>- Appointment reminders<br>- New messages<br>- System updates<br>- Donation requests |
| **Blood Request Notifications** | <img src="BloodConnect/Views/Resources/images/notification%20on%20blood%20request.png" width="250" style="border-radius: 10px;"> | **Smart Notification System**:<br>- Real-time alerts for matching blood types<br>- Geo-fenced notifications<br>- Priority-based delivery<br>- Request history tracking<br>- Firebase synchronization |
| **User Profile** | <img src="BloodConnect/Views/Resources/images/ProfilePageUsersown.png" width="250" style="border-radius: 10px;"> | **Features**:<br>- Personal information management<br>- Donation history<br>- Settings customization<br>- Privacy controls<br>- Account preferences |

## 🌟 Features

### Core Features
- 🔍 **Smart Donor Search**: Find compatible blood donors in your vicinity
- 📱 **Real-time Notifications**: Instant alerts for blood requests
- 🏥 **Hospital Integration**: Seamless connection with local hospitals and blood banks
- 📊 **Donation Tracker**: Comprehensive history of your blood donations
- 🔐 **Secure Authentication**: Biometric and multi-factor authentication
- 📍 **Location Services**: Precise location-based donor matching
- 💬 **Messaging System**: Direct communication between donors and recipients

### Advanced Features
- 🎯 **Blood Type Matching**: Intelligent compatibility checking
- 📈 **Analytics Dashboard**: Track donation trends and impact
- 🚨 **Emergency Mode**: Priority handling for urgent requests
- 🤝 **Community Building**: Connect with regular donors
- 📅 **Scheduling System**: Easy appointment management
- 🏆 **Rewards Program**: Incentives for regular donors

### New Features
- 🌐 **Geo-Fenced Notifications**: Smart radius-based alert system
- 🔄 **Real-time Sync**: Instant Firebase synchronization
- 📝 **Request History**: Track all blood requests
- 🎯 **Smart Matching**: Automatic donor-recipient matching
- 📊 **Analytics**: Track request success rates

## 📱 Screenshots

| Feature | Screenshot |
|---------|------------|
| Home Screen | *Coming Soon* |
| Donor Search | *Coming Soon* |
| Request Blood | *Coming Soon* |
| Profile | *Coming Soon* |

## 🏗️ Project Structure

```
BloodConnect/
├── AppDelegate.swift          # App lifecycle management
├── SceneDelegate.swift        # Scene management
├── ViewController.swift       # Main view controller
├── Models/                    # Data models
│   ├── User.swift            # User profile and authentication
│   ├── BloodRequest.swift    # Blood request management
│   ├── Donation.swift        # Donation tracking
│   └── Hospital.swift        # Hospital integration
├── Views/                     # UI components
│   ├── Authentication/       # Login and registration
│   ├── Home/                 # Main dashboard
│   ├── Profile/              # User profile
│   ├── Requests/             # Blood requests
│   └── Components/           # Reusable UI elements
├── Controllers/              # Business logic
│   ├── AuthController.swift  # Authentication logic
│   ├── BloodRequestController.swift # Request management
│   ├── UserController.swift  # User management
│   └── LocationController.swift # Location services
├── Services/                 # Network and data services
│   ├── AuthService.swift     # Authentication service
│   ├── DatabaseService.swift # Database operations
│   ├── LocationService.swift # Location handling
│   └── NotificationService.swift # Push notifications
├── Utils/                    # Helper functions
│   ├── Constants.swift       # App constants
│   ├── Extensions.swift      # Swift extensions
│   └── Helpers.swift         # Utility functions
└── Resources/                # App resources
    ├── Assets.xcassets/      # Images and assets
    └── Localization/         # Localization files
```

## 🚀 Getting Started

### Prerequisites

- Xcode 12.0 or later
- iOS 14.0 or later
- CocoaPods
- Firebase account
- Apple Developer account
- Physical iOS device (recommended)

### Installation

1. Clone the repository
```bash
git clone https://github.com/sanidhyapandey/BloodConnect.git
cd BloodConnect
```

2. Install dependencies
```bash
pod install
```

3. Open the workspace
```bash
open BloodConnect.xcworkspace
```

4. Configure Firebase
- Add your `GoogleService-Info.plist` to the project
- Enable required Firebase services:
  - Authentication
  - Firestore
  - Cloud Messaging
  - Storage
  - Analytics

5. Configure Signing
- Open Xcode project settings
- Select your team
- Update bundle identifier
- Enable necessary capabilities

## 🏛️ Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern with the following components:

- **Models**: Data structures and business logic
- **Views**: UI components and SwiftUI views
- **ViewModels**: Business logic and data binding
- **Services**: Network and data operations
- **Repositories**: Data access layer

## 📚 API Documentation

### Authentication
```swift
// User Authentication
func signIn(email: String, password: String)
func signUp(user: User)
func signOut()
```

### Blood Requests
```swift
// Blood Request Management
func createRequest(request: BloodRequest)
func getNearbyRequests(location: CLLocation)
func updateRequestStatus(requestId: String, status: RequestStatus)
```

### Donations
```swift
// Donation Tracking
func recordDonation(donation: Donation)
func getDonationHistory(userId: String)
func updateDonationStatus(donationId: String, status: DonationStatus)
```

## 🧪 Testing

### Unit Tests
```bash
xcodebuild test -scheme BloodConnect -destination 'platform=iOS Simulator,name=iPhone 14'
```

### UI Tests
```bash
xcodebuild test -scheme BloodConnect -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:BloodConnectUITests
```

## 🚢 Deployment

1. Update version number in Xcode
2. Run tests
3. Archive the project
4. Upload to App Store Connect
5. Submit for review

## 🛠️ Built With

- [Swift](https://swift.org) - Modern, safe, and fast programming language
- [Firebase](https://firebase.google.com) - Backend services and real-time database
- [CocoaPods](https://cocoapods.org) - Dependency management
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Modern UI framework
- [CoreLocation](https://developer.apple.com/documentation/corelocation) - Location services
- [UserNotifications](https://developer.apple.com/documentation/usernotifications) - Push notifications

## 🤝 Contributing

We love contributions! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow Swift style guide
- Use meaningful variable names
- Add comments for complex logic
- Write unit tests for new features

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Sanidhya Pandey** - *Lead Developer* - [GitHub](https://github.com/sanidhyapandey)
- **Contributors** - See [contributors](https://github.com/sanidhyapandey/BloodConnect/contributors)

## 🙏 Acknowledgments

- Apple Developer Documentation
- Firebase Team
- Open Source Community
- Blood Donation Organizations
- Medical Professionals
- Beta Testers

## 📞 Contact

Sanidhya Pandey - [LinkedIn](https://linkedin.com/in/sanidhyapandey) - [Twitter](https://twitter.com/sanidhyapandey)

Project Link: [https://github.com/sanidhyapandey/BloodConnect](https://github.com/sanidhyapandey/BloodConnect)

## 📊 Statistics

![GitHub stars](https://img.shields.io/github/stars/sanidhyapandey/BloodConnect?style=social)
![GitHub forks](https://img.shields.io/github/forks/sanidhyapandey/BloodConnect?style=social)
![GitHub issues](https://img.shields.io/github/issues/sanidhyapandey/BloodConnect)
![GitHub pull requests](https://img.shields.io/github/issues-pr/sanidhyapandey/BloodConnect) 
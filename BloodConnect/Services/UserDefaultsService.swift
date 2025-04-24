import Foundation

class UserDefaultsService {
    
    // MARK: - Singleton
    static let shared = UserDefaultsService()
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let rememberMe = "rememberMe"
        static let email = "email"
        static let darkMode = "darkMode"
        static let notificationsEnabled = "notificationsEnabled"
        static let bloodTypeFilter = "bloodTypeFilter"
        static let locationSearchRadius = "locationSearchRadius"
        static let lastOpenDate = "lastOpenDate"
        static let onboardingCompleted = "onboardingCompleted"
        static let languageCode = "languageCode"
    }
    
    // MARK: - UserDefaults instance
    private let defaults = UserDefaults.standard
    
    // MARK: - Authentication Settings
    
    var rememberMe: Bool {
        get { defaults.bool(forKey: Keys.rememberMe) }
        set { defaults.set(newValue, forKey: Keys.rememberMe) }
    }
    
    var savedEmail: String? {
        get { defaults.string(forKey: Keys.email) }
        set { defaults.set(newValue, forKey: Keys.email) }
    }
    
    func saveLoginCredentials(email: String) {
        self.rememberMe = true
        self.savedEmail = email
    }
    
    func clearLoginCredentials() {
        self.rememberMe = false
        self.savedEmail = nil
    }
    
    // MARK: - Appearance Settings
    
    var isDarkMode: Bool {
        get { defaults.bool(forKey: Keys.darkMode) }
        set { defaults.set(newValue, forKey: Keys.darkMode) }
    }
    
    // MARK: - Notification Settings
    
    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }
    
    // MARK: - Search Settings
    
    var bloodTypeFilter: String? {
        get { defaults.string(forKey: Keys.bloodTypeFilter) }
        set { defaults.set(newValue, forKey: Keys.bloodTypeFilter) }
    }
    
    var locationSearchRadius: Double {
        get { defaults.double(forKey: Keys.locationSearchRadius) }
        set { defaults.set(newValue, forKey: Keys.locationSearchRadius) }
    }
    
    // MARK: - App State
    
    var lastOpenDate: Date? {
        get { defaults.object(forKey: Keys.lastOpenDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastOpenDate) }
    }
    
    var onboardingCompleted: Bool {
        get { defaults.bool(forKey: Keys.onboardingCompleted) }
        set { defaults.set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    // MARK: - Localization
    
    var languageCode: String? {
        get { defaults.string(forKey: Keys.languageCode) }
        set { defaults.set(newValue, forKey: Keys.languageCode) }
    }
    
    // MARK: - Reset
    
    /// Resets all saved settings to their default values
    func resetAllSettings() {
        let keys = [
            Keys.rememberMe,
            Keys.email,
            Keys.darkMode, 
            Keys.notificationsEnabled,
            Keys.bloodTypeFilter,
            Keys.locationSearchRadius,
            Keys.lastOpenDate,
            Keys.onboardingCompleted,
            Keys.languageCode
        ]
        
        for key in keys {
            defaults.removeObject(forKey: key)
        }
    }
} 
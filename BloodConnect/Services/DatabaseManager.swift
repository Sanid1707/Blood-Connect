import Foundation
import SwiftData

/// A class that manages the app's database schema, migrations, and provides access to model containers and contexts
@MainActor
class DatabaseManager {
    // MARK: - Singleton
    static let shared = DatabaseManager()
    
    // MARK: - Properties
    private(set) var modelContainer: ModelContainer
    private(set) var mainContext: ModelContext
    
    // MARK: - Initialization
    private init() {
        do {
            self.modelContainer = try Self.createModelContainer()
            self.mainContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize database: \(error)")
        }
    }
    
    // MARK: - Setup Methods
    
    private static func createModelContainer() throws -> ModelContainer {
        let schema = Schema([
            UserModel.self,
            BloodSeekerModel.self,
            DonationCenterModel.self,
            OperatingHoursModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    }
    
    // MARK: - Context Methods
    
    /// Creates a new background context for performing database operations off the main thread
    func newBackgroundContext() -> ModelContext {
        return ModelContext(modelContainer)
    }
    
    // MARK: - Migration Methods
    
    /// Prepares the database for the current app version, including any migrations
    func prepareDatabase() {
        // This method would handle migrations between app versions
        // For now, it's just a placeholder as we don't have version migrations yet
        print("Database prepared")
    }
    
    // MARK: - Utility Methods
    
    /// Resets the database by deleting all data (for development/testing)
    func resetDatabase() throws {
        // This would delete everything in the database
        // Use with caution!
        
        // Delete each model type
        try deleteAllEntities(ofType: UserModel.self)
        try deleteAllEntities(ofType: BloodSeekerModel.self)
        try deleteAllEntities(ofType: DonationCenterModel.self)
        try deleteAllEntities(ofType: OperatingHoursModel.self)
        
        print("Database reset complete")
    }
    
    /// Helper method to delete all entities of a specific type
    private func deleteAllEntities<T: PersistentModel>(ofType type: T.Type) throws {
        let descriptor = FetchDescriptor<T>()
        let entities = try mainContext.fetch(descriptor)
        
        for entity in entities {
            mainContext.delete(entity)
        }
        
        try mainContext.save()
    }
} 
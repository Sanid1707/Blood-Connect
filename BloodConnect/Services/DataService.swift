import Foundation
import Combine
import SwiftData

// MARK: - Data Service Protocol
@preconcurrency
protocol DataServiceProtocol {
    func createUser(_ user: User) -> AnyPublisher<User, Error>
    func getUser(byId id: String) -> AnyPublisher<User?, Error>
    func updateUser(_ user: User) -> AnyPublisher<User, Error>
    func deleteUser(byId id: String) -> AnyPublisher<Bool, Error>
    // other methods omitted for brevity
}

enum DataServiceError: Error {
    case invalidData
    case modelNotFound
    case saveFailed
    case deleteFailed
    case fetchFailed
}

@MainActor
@preconcurrency
class SwiftDataService: DataServiceProtocol {
    private var modelContext: ModelContext

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext ?? DatabaseManager.shared.mainContext
    }

    func createUser(_ user: User) -> AnyPublisher<User, Error> {
        return Future<User, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(DataServiceError.saveFailed))
                return
            }
            do {
                let userModel = UserModel(from: user)
                self.modelContext.insert(userModel)
                try self.modelContext.save()
                promise(.success(userModel.toUser()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func getUser(byId id: String) -> AnyPublisher<User?, Error> {
        return Future<User?, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(DataServiceError.fetchFailed))
                return
            }
            do {
                let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.id == id })
                let users = try self.modelContext.fetch(descriptor)
                promise(.success(users.first?.toUser()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func updateUser(_ user: User) -> AnyPublisher<User, Error> {
        return Future<User, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(DataServiceError.saveFailed))
                return
            }
            guard let userId = user.id else {
                promise(.failure(DataServiceError.invalidData))
                return
            }
            do {
                let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.id == userId })
                let users = try self.modelContext.fetch(descriptor)
                if let userModel = users.first {
                    userModel.name = user.name
                    userModel.email = user.email
                    userModel.phoneNumber = user.phoneNumber
                    userModel.bloodType = user.bloodType?.rawValue
                    userModel.lastDonationDate = user.lastDonationDate
                    userModel.donationCount = user.donationCount
                    userModel.county = user.county
                    userModel.userType = user.userType
                    userModel.availability = user.availability
                    userModel.address = user.address
                    userModel.latitude = user.latitude
                    userModel.longitude = user.longitude
                    try self.modelContext.save()
                    promise(.success(userModel.toUser()))
                } else {
                    promise(.failure(DataServiceError.modelNotFound))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteUser(byId id: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(DataServiceError.deleteFailed))
                return
            }
            do {
                let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.id == id })
                let users = try self.modelContext.fetch(descriptor)
                if let user = users.first {
                    self.modelContext.delete(user)
                    try self.modelContext.save()
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - BloodRequest Operations
    func createBloodRequest(_ request: BloodRequest, userId: String) -> AnyPublisher<BloodRequest, Error> {
        return Future<BloodRequest, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.saveFailed))
                return
            }
            
            do {
                let requestModel = BloodRequestModel(
                    title: request.title,
                    requestDescription: request.requestDescription,
                    bloodType: request.bloodType,
                    urgency: request.urgency,
                    status: request.status,
                    location: request.location,
                    latitude: request.latitude,
                    longitude: request.longitude,
                    radiusKm: request.radiusKm,
                    userId: userId,
                    organizationName: request.organizationName
                )
                
                self.modelContext.insert(requestModel)
                try self.modelContext.save()
                promise(.success(requestModel.toBloodRequest()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func getBloodRequests() -> AnyPublisher<[BloodRequest], Error> {
        return Future<[BloodRequest], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.fetchFailed))
                return
            }
            
            do {
                let descriptor = FetchDescriptor<BloodRequestModel>()
                let bloodRequests = try self.modelContext.fetch(descriptor)
                let result = bloodRequests.map { $0.toBloodRequest() }
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - DonationCenter Operations
    func createDonationCenter(_ center: DonationCenter) -> AnyPublisher<DonationCenter, Error> {
        return Future<DonationCenter, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.saveFailed))
                return
            }
            
            do {
                let centerModel = DonationCenterModel(from: center)
                self.modelContext.insert(centerModel)
                try self.modelContext.save()
                promise(.success(centerModel.toDonationCenter()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func getDonationCenters() -> AnyPublisher<[DonationCenter], Error> {
        return Future<[DonationCenter], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.fetchFailed))
                return
            }
            
            do {
                let descriptor = FetchDescriptor<DonationCenterModel>()
                let centers = try self.modelContext.fetch(descriptor)
                let result = centers.map { $0.toDonationCenter() }
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func getDonationCenter(byId id: String) -> AnyPublisher<DonationCenter?, Error> {
        return Future<DonationCenter?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.fetchFailed))
                return
            }
            
            do {
                let descriptor = FetchDescriptor<DonationCenterModel>(predicate: #Predicate { $0.id == id })
                let centers = try self.modelContext.fetch(descriptor)
                if let center = centers.first {
                    promise(.success(center.toDonationCenter()))
                } else {
                    promise(.success(nil))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func updateDonationCenter(_ center: DonationCenter) -> AnyPublisher<DonationCenter, Error> {
        return Future<DonationCenter, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.saveFailed))
                return
            }
            
            do {
                let descriptor = FetchDescriptor<DonationCenterModel>(predicate: #Predicate { $0.id == center.id })
                let centers = try self.modelContext.fetch(descriptor)
                if let centerModel = centers.first {
                    // Update properties
                    centerModel.name = center.name
                    centerModel.address = center.address
                    centerModel.city = center.city
                    centerModel.state = center.state
                    centerModel.zipCode = center.zipCode
                    centerModel.phoneNumber = center.phoneNumber
                    centerModel.email = center.email
                    centerModel.website = center.website
                    centerModel.latitude = center.latitude
                    centerModel.longitude = center.longitude
                    
                    // Delete existing operating hours and recreate
                    for hour in centerModel.operatingHours {
                        self.modelContext.delete(hour)
                    }
                    centerModel.operatingHours = []
                    
                    // Add new operating hours
                    let newHours = center.operatingHours.map { hour in
                        OperatingHoursModel(
                            day: hour.day.rawValue,
                            openTime: hour.openTime,
                            closeTime: hour.closeTime,
                            isClosed: hour.isClosed
                        )
                    }
                    centerModel.operatingHours = newHours
                    
                    // Update blood types and needs
                    centerModel.acceptedBloodTypes = center.acceptedBloodTypes.map { $0.rawValue }
                    centerModel.currentNeedLevels = center.currentNeed.map { $0.rawValue }
                    
                    try self.modelContext.save()
                    promise(.success(centerModel.toDonationCenter()))
                } else {
                    promise(.failure(DataServiceError.modelNotFound))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteDonationCenter(byId id: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DataServiceError.deleteFailed))
                return
            }
            
            do {
                let descriptor = FetchDescriptor<DonationCenterModel>(predicate: #Predicate { $0.id == id })
                let centers = try self.modelContext.fetch(descriptor)
                if let center = centers.first {
                    self.modelContext.delete(center)
                    try self.modelContext.save()
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

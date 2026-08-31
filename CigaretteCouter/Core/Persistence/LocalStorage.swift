//
//  LocalStorage.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//
import Foundation

protocol LocalStorageProtocol: Sendable {
    
    func saveCigarette(_ cigarette: CigaretteModel) throws
    
    func getCigarettes(
        from startDate: Date,
        to endDate: Date
    ) -> [CigaretteModel]
    
    func getAllCigarettes() -> [CigaretteModel]
    
    func getCigarette(id: String) -> CigaretteModel?
    
    func deleteCigarette(id: String) throws
    
    func saveUser(_ user: UserModel) throws
    
    func getUser() -> UserModel?
    
    func saveUserSettings(_ settings: UserSettingModel) throws
    
    func getUserSettings() -> UserSettingModel
    
    func deleteAll() async throws
    
}

final class LocalStorage: LocalStorageProtocol, @unchecked Sendable {
    
    static let shared = LocalStorage()
    
    private let userDefaults = UserDefaults.standard
    
    private let cigarettesKey = "cc_local_cigarettes"
    private let userKey = "cc_local_user"
    private let settingsKey = "cc_local_user_settings"
    
    private let lock = NSLock()
    
    private init() {}
    
    // MARK: - Cigarettes
    
    func saveCigarette(
        _ cigarette: CigaretteModel
    ) throws {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        var existing = getCigarettesInternal()
        
        if let index = existing.firstIndex(
            where: { $0.id == cigarette.id }
        ) {
            existing[index] = cigarette
        } else {
            existing.append(cigarette)
        }
        
        let data = try JSONEncoder().encode(existing)
        
        userDefaults.set(
            data,
            forKey: cigarettesKey
        )
    }
    
    func getCigarettes(
        from startDate: Date,
        to endDate: Date
    ) -> [CigaretteModel] {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        return getCigarettesInternal()
            .filter {
                $0.smokedAt >= startDate &&
                $0.smokedAt < endDate
            }
            .sorted {
                $0.smokedAt < $1.smokedAt
            }
    }
    
    func getAllCigarettes() -> [CigaretteModel] {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        return getCigarettesInternal()
            .sorted {
                $0.smokedAt < $1.smokedAt
            }
    }
    
    func getCigarette(
        id: String
    ) -> CigaretteModel? {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        return getCigarettesInternal()
            .first {
                $0.id == id
            }
    }
    
    func deleteCigarette(
        id: String
    ) throws {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        var existing = getCigarettesInternal()
        
        existing.removeAll {
            $0.id == id
        }
        
        let data = try JSONEncoder().encode(existing)
        
        userDefaults.set(
            data,
            forKey: cigarettesKey
        )
    }
    
    
    func deleteAll() throws {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        let emptyCigarettes: [CigaretteModel] = []
        
        let data = try JSONEncoder().encode(emptyCigarettes)
        
        userDefaults.set(
            data,
            forKey: cigarettesKey
        )
    }
    
    
    // MARK: - User
    
    func saveUser(
        _ user: UserModel
    ) throws {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        let data = try JSONEncoder().encode(user)
        
        userDefaults.set(
            data,
            forKey: userKey
        )
    }
    
    func getUser() -> UserModel? {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard let data = userDefaults.data(
            forKey: userKey
        ) else {
            return nil
        }
        
        return try? JSONDecoder().decode(
            UserModel.self,
            from: data
        )
    }
    
    // MARK: - User Settings
    
    func saveUserSettings(
        _ settings: UserSettingModel
    ) throws {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        let data = try JSONEncoder().encode(settings)
        
        userDefaults.set(
            data,
            forKey: settingsKey
        )
    }
    
    func getUserSettings() -> UserSettingModel {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard
            let data = userDefaults.data(
                forKey: settingsKey
            ),
            let settings = try? JSONDecoder().decode(
                UserSettingModel.self,
                from: data
            )
        else {
            return UserSettingModel()
        }
        
        return settings
    }
    
    // MARK: - Private
    
    private func getCigarettesInternal() -> [CigaretteModel] {
        guard let data = userDefaults.data(forKey: cigarettesKey) else { return [] }
        return (try? JSONDecoder().decode([CigaretteModel].self,from: data)) ?? []
    }
    
}

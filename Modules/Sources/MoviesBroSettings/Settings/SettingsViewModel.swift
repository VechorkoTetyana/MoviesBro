import UIKit
import MoviesBroCore
import MoviesBroAuthentication
import Swinject

struct Header {
    let imageUrl: URL?
    let name: String
    let location: String
}

public final class SettingsViewModel {
    
    var header: Header
    
    private let authService: AuthService
    private let userRepository: UserProfileRepository
    private let profilePictureRepository: ProfilePictureRepository
    
    private let container: Container
    private let coordinator: SettingsCoordinator
    
    var didUpdateHeader: (() -> ())?
    
    public init(
        container: Container,
        coordinator: SettingsCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
        self.authService = container.resolve(AuthService.self)!
        self.userRepository = container.resolve(UserProfileRepository.self)!
        self.profilePictureRepository = container.resolve(ProfilePictureRepository.self)!

        self.header = Header(
            imageUrl: nil,
            name: "Setup Your Name",
            location: "No Location"
        )
    }
    
    func logout() throws {
        try authService.logout()
        NotificationCenter.default.post(.didLogout)
    }
    
    func presentProfileEdit() {
        coordinator.presentProfileEdit()
    }
    
    func fetchUserProfile() {
        Task { [weak self] in
            do {
                guard let profile = try await self?.userRepository.fetchUserProfile()
                else { return }
                                
                await MainActor.run { [weak self] in
                    self?.updateHeader(with: profile)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func updateHeader(with userProfile: UserProfile) {
        self.header = Header(
            imageUrl: userProfile.profilePictureUrl,
            name: userProfile.fullName,
            location: userProfile.location
        )
        
        didUpdateHeader?()
    }
}


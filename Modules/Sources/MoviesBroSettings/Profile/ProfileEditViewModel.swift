import UIKit
import DesignSystem
import MoviesBroAuthentication
import MoviesBroCore
import Swinject

enum TextFieldType {
    case name
    case location
}

enum Row {
    case profilePicture
    case textField(TextFieldType)
}

public final class ProfileEditViewModel {
    
    var selectedImage: UIImage?
    var fullName: String = ""
    var location: String = ""
    var profilePictureUrl: URL?
    
    var rows: [Row]
    
    private let userProfileRepository: UserProfileRepository
    private let profilePictureRepository: ProfilePictureRepository
    private let container: Container
    private let coordinator: ProfileCoordinator
    
   init(
    container: Container,
    coordinator: ProfileCoordinator
    ) {
        self.container = container
        self.coordinator = coordinator
        self.userProfileRepository = container.resolve(UserProfileRepository.self)!
        self.profilePictureRepository = container.resolve(ProfilePictureRepository.self)!
        
        if let profile = userProfileRepository.profile {
            fullName = profile.fullName
            location = profile.location
            profilePictureUrl = profile.profilePictureUrl
        }
        
        rows = [
            .profilePicture,
            .textField(.name),
            .textField(.location)
        ]
    }
    
    func save() async throws {
        let profile = UserProfile(
            fullName: fullName,
            location: location,
            profilePictureUrl: nil
        )
        if let selectedImage {
            try await profilePictureRepository.upload(selectedImage)
        }
        
        try userProfileRepository.saveUserProfile(profile)
        
        await MainActor.run {
            coordinator.dismiss()
        }
    }
    
    func modelForTextFieldRow(_ type: TextFieldType) -> ProfileTextFieldCell.Model {
        switch type {
        case .name:
            ProfileTextFieldCell.Model(
                icon: UIImage(resource: .user),
                placeholderText: "Your name",
                text: fullName,
                isValid: isFullNameValid()
            )
        case .location:
            ProfileTextFieldCell.Model(
                icon: UIImage(resource: .location),
                placeholderText: "Location",
                text: location,
                isValid: isLocationValid()
            )
        }
    }
        
        private func isFullNameValid() -> Bool {
            fullName.count > 2
        }
    
    private func isLocationValid() -> Bool {
        location.count > 2
    }
}




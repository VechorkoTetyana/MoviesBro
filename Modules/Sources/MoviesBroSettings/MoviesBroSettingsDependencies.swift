import Foundation
import MoviesBroAuthentication

public protocol MoviesBroSettingsDependencies {
    var authService: AuthService { get }
    var userRepository: UserProfileRepository { get }
    var profilePictureRepository: ProfilePictureRepository { get }
    
}

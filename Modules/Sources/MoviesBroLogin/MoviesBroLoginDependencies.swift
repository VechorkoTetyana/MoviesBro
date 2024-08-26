import Foundation
import MoviesBroAuthentication

public protocol MoviesBroLoginDependencies {
    var authService: AuthService { get }
}

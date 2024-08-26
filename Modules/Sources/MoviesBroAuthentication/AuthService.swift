import FirebaseAuth

// https://github.com/firebase/firebase-ios-sdk

public enum AuthError: Error {
    case noVerificationID
}

public struct User {
    public let uid: String
    
    public init(uid: String) {
        self.uid = uid
    }
}

enum UserDefaultKey: String {
    case authVerificationID
}

public protocol AuthService {
    
    var user: User? { get }
    var isAuthenticated: Bool { get }
    
    func requestOTP(forPhoneNumber phoneNumber: String) async throws
    func authenticate(withOTP otp: String) async throws -> User
    func logout() throws
}

public class AuthServiceLive: AuthService {
    
        public var isAuthenticated: Bool {
            Auth.auth().currentUser != nil
    }
    
    public var user: User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return User(uid: user.uid)
    }
    
    public init() {}
    
    public func requestOTP(forPhoneNumber phoneNumber: String) async throws {
        
        let verificationID = try await  PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
   
        UserDefaults.standard.set(verificationID, forKey: UserDefaultKey.authVerificationID.rawValue)
    }
    
    public func authenticate(withOTP otp: String) async throws -> User {
        
        guard let verificationID = UserDefaults.standard.string(forKey: UserDefaultKey.authVerificationID.rawValue) else {
            throw AuthError.noVerificationID
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        
        let result = try await Auth.auth().signIn(with: credential)
        result.user.uid
        
        return User(uid: result.user.uid)
    }
    
    public func logout() throws {
        try Auth.auth().signOut()
    }
}


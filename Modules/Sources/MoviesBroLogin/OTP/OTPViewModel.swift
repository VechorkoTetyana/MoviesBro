import UIKit
import MoviesBroAuthentication
import Swinject


enum OTPViewModelError: Error {
    case otpNotValid
}

public final class OTPViewModel {

    private var authService: AuthService

    let phoneNumber: String

    init(container: Container, phoneNumber: String) {
        self.authService = container.resolve(AuthService.self)!
        self.phoneNumber = phoneNumber
    }

    func verifyOTP(with digits: [String]) async throws {
        guard digits.count == 6, validate(digits: digits) else {
            throw OTPViewModelError.otpNotValid
        }

        let otp = combineToOTP(digits: digits)
        print("OTP\(otp)")
        let user = try await authService.authenticate(withOTP: otp)
        print(user.uid)
    }

    private func validate(digits: [String]) -> Bool {
        for digit in digits {
            guard digit.isValidDigit else { return false }
        }

        return true
    }

    private func combineToOTP(digits: [String]) -> String {
        digits.joined()
    }
}

fileprivate extension String {
    var isValidDigit: Bool {
        guard count == 1 else { return false }
        guard isNumber else { return false }
        return true
    }
}

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
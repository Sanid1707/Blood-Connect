//
//
//import SwiftUI
//import Combine
//
//class RegisterViewController {
//    private let authService: AuthService
//    
//    init(authService: AuthService = AuthService()) {
//        self.authService = authService
//    }
//    
//    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
//        // Validate inputs
//        guard !email.isEmpty else {
//            return Fail(error: AuthError.emptyEmail).eraseToAnyPublisher()
//        }
//        
//        guard !password.isEmpty else {
//            return Fail(error: AuthError.emptyPassword).eraseToAnyPublisher()
//        }
//        
//        // Call auth service
//        return authService.signIn(email: email, password: password)
//    }
//    
//    func signInWithGoogle() -> AnyPublisher<User, Error> {
//        return authService.signInWithGoogle()
//    }
//    
//    func signInWithApple() -> AnyPublisher<User, Error> {
//        return authService.signInWithApple()
//    }
//    
//    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
//        guard !email.isEmpty else {
//            return Fail(error: AuthError.emptyEmail).eraseToAnyPublisher()
//        }
//        
//        return authService.resetPassword(email: email)
//    }
//}
//
//
////

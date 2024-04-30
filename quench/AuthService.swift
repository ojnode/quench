//
//  AuthService.swift
//  quench
//
//  Created by prince ojinnaka on 30/04/2024.
//

import FirebaseAuth

final class AuthService {
    
    private let auth = Auth.auth()
    
    static let shared = AuthService()
    
    private init() { }
    
    func registerEmail(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        print(result)
    }
    
    func signInEmail(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        print(result.user)
    }
}

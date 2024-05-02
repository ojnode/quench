//
//  AuthService.swift
//  quench
//
//  Created by prince ojinnaka on 30/04/2024.
//

import FirebaseAuth


@Observable
final class AuthService {
    
    var currentUser: FirebaseAuth.User?
    private let auth = Auth.auth()
    
    static let shared = AuthService()
    
    private init() { 
        currentUser = auth.currentUser
    }
    
    func registerEmail(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser = result.user
    }
    
    func signInEmail(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        currentUser = result.user
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
    }
}

//
//  AuthService.swift
//  quench
//
//  Created by prince ojinnaka on 30/04/2024.
//

import FirebaseAuth
// REAAADDD THIS
// READ THIS
// READ THIS
//READ THIS
//READ THIS
//READ THIS
// first after creating , it shouldnt assign a value to currentuser raher take back to sign in page, correct later
// enable app check also so this damn thingworks on simulator
@Observable
final class AuthService {
    
    var currentUser: FirebaseAuth.User?
    private let auth = Auth.auth()
    
    static let shared = AuthService()
    
    private init() {
        currentUser = auth.currentUser
    }
    
    func registerEmail(email: String, password: String, firstName: String, lastName: String) async throws {
        let displayName = "\(firstName) \(lastName)"
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser = result.user
        let changeRequest = currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
    }
    
    func signInEmail(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        currentUser = result.user
    }
    
    func signOut() {
        do {try auth.signOut()
            currentUser = nil
        } catch {
            print("Sign out no work")
        }
    }
}

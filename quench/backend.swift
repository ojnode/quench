//
//  backend.swift
//  quench
//
//  Created by prince ojinnaka on 19/06/2024.
//

import FirebaseFirestore
import FirebaseAuth

enum userID: Error {
    case IDnotfound
}

struct firebaseStoreUser {
    let db = Firestore.firestore().collection("users")
    let currentUser = Auth.auth().currentUser
    
    func getUserID() throws -> String {
        guard let user = currentUser?.uid else {
            throw userID.IDnotfound
        }
        return user
    }
    
    // implement offline capablities later
    func getData() async throws {
        let docRef = db.document(try self.getUserID())
        let doc = try await docRef.getDocument().data()
        
        
    }
}


struct CalculateBMI {
    var db = firebaseStoreUser().db
 //   var user = try firebaseStoreUser().getUserID()
    
    func getUser() -> String {
        do {
            return try firebaseStoreUser().getUserID()
        } catch {
            return "something went wrong"
        }
    }

}

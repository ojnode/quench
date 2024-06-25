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
    
    func getData() async throws -> [String :Any]? {
        let docRef = db.document(try self.getUserID())
        let doc = try await docRef.getDocument().data()
        return doc
    }
}

class CalculateBMI {
    
    let doc = firebaseStoreUser()
    var attributesList: [String: Any] = [:]
    var BMIResults: Double = 0
    
    func setBMI() async throws {
        guard let attributes = try await doc.getData()
        else {
            throw RetrieveDataErrors.attributesError
        }
        for (key, value) in attributes {
            if key == "weight" || key == "height" {
                attributesList.updateValue(value, forKey: key)
            }
        }
        
        guard let unwrappedHeight = attributesList["height"] as? Any,
              let unwrappedWeight = attributesList["weight"] as? Any else {
            throw RetrieveDataErrors.attributesError
        }
        
        guard let stringHeight = unwrappedHeight as? String,
              let stringWeight = unwrappedWeight as? String else {
            throw RetrieveDataErrors.attributesError
        }
        
        let wrappedHeight = Double(stringHeight)
        let wrappedWeight = Double(stringWeight)
        
        guard let height = wrappedHeight as? Double,
              let weight = wrappedWeight as? Double
        else {
            throw RetrieveDataErrors.attributesError
        }
        BMIResults = weight / height
    }
}

func printBMI() async {
    let BMI = CalculateBMI()
    
    do {
        try await BMI.setBMI()
    } catch {
        print("e no work")
    }
    print(BMI.BMIResults)

}

enum RetrieveDataErrors: Error {
    case attributesError
}

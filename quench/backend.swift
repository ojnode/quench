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
    var BMI: Double = 0
    
    func getBMI() async throws {
        guard let attributes = try await doc.getData()
        else {
            throw RetrieveDataErrors.attributesError
        }
        for (key, value) in attributes {
            if key == "weight" || key == "height" {
                attributesList.updateValue(value, forKey: key)
            }
        }
        
        // First, unwrap the Any type
        guard let weightUnwrapped = attributesList["weight"] as? Any,
              let heightUnwrapped = attributesList["height"] as? Any else {
            throw RetrieveDataErrors.attributesError
        }

        // Then, try to convert to Double
        let weight: Double
        let height: Double

        if let weightDouble = weightUnwrapped as? Double {
            weight = weightDouble
        } else if let weightString = weightUnwrapped as? String,
                  let weightDouble = Double(weightString) {
            weight = weightDouble
        } else {
            throw RetrieveDataErrors.attributesError
        }
        
        if let heightDouble = heightUnwrapped as? Double {
            height = heightDouble
        } else if let heightString = heightUnwrapped as? String,
                  let heightDouble = Double(heightString) {
            height = heightDouble
        } else {
            throw RetrieveDataErrors.attributesError
        }
        
        print("\(weight / height)")
//        guard let weight = attributesList["weight"]  as? Double,
//              let height = attributesList["height"]  as? Double else {
//            throw RetrieveDataErrors.attributesError
//        }

//    print("is it working 3")
//    print(attributesList)
//    let weight = attributesList["weight"] as? Double
//    let height = attributesList["height"] as? Double
//    let BMI = weight! / height! * 2
//    return BMI
}
}

func printBMI() async {
    let BMI = CalculateBMI()
    
    do {
        let BMIResults = try await BMI.getBMI()
    } catch {
        print("e no work")
    }
    
}

enum RetrieveDataErrors: Error {
    case attributesError
}

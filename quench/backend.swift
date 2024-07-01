//
//  backend.swift
//  quench
//
//  Created by prince ojinnaka on 19/06/2024.
//

import FirebaseFirestore
import FirebaseAuth

struct storeAttributes  {
    var birthday: Date
    var weight: String
    var height: String
    var gender: String
    var reduction: Double
    
    func storeData() async -> [String] {
        var errorList = [String]()
        let stringReduction = String(format:"%.2f%", reduction)
        let age = Calendar.current.dateComponents([.year], from: birthday,
                                                  to: Date())
           .year
        let data: [String: String] = ["age": String(age ?? 0), "weight": weight,
                                      "height": height, "gender": gender, "reduction": stringReduction]
        
        for (key, value) in data {
            do {
                if key != "gender" {
                    try await valueValidation(key: key, value: value)
                }
            } catch let error as storageValidation {
                if case let .incorrectValue(string) = error {
                    errorList.append(string)
                }
            } catch {
                errorList.append("Something went wrong")
            }
        }
        
        if errorList.isEmpty {
            do {
                try await createDatabase(data: data)
            } catch let error as storageValidation {
                if case let .errorAddingDocument(string) = error {
                    errorList.append(string)
                }
            } catch {
                errorList.append("Something went wrong")
            }
        } else {
                return errorList
            }
        return errorList // remove later and implement optional
        }
}

enum storageValidation: Error {
    case errorAddingDocument(String)
    case incorrectValue(String)
}

// consider external names and local names to imrpove readablitiyi
func createDatabase(data: [String: String]) async throws {
    let db = FirebaseStoreUser().db
    let user = try FirebaseStoreUser().getUserID()
    try await db.document(user).setData(data)
}

func valueValidation(key: String, value: String) async throws -> Double {
    guard let doublevalue = Double(value) else {
        throw storageValidation.incorrectValue("invalid \(key) input")
    }
    
    if doublevalue < 0 {
        throw storageValidation.incorrectValue("invalid \(key) input")
    }
    
    return doublevalue
}


struct UserSession {
    var password = ""
    var firstName = ""
    var lastName = ""
    var userName = ""
    var email = ""
    
    func signInWithEmail() async throws -> Bool {
            do {
               try await AuthService.shared.signInEmail(email: email, password: password)
                return true
            } catch {
                throw LogStatusError.authorizationDenied("\(error.localizedDescription)")
            }
    }
    
    func signUpWithEmail() async throws -> Bool {
            do {
               try await AuthService.shared.registerEmail(email: email, password: password,
                                                          firstName: firstName, lastName: lastName)
                return true
            } catch {
                throw LogStatusError.authorizationDenied("\(error.localizedDescription)")
            }
    }
}

enum LogStatusError: Error {
    case authorizationDenied(String)
}
enum userID: Error {
    case IDnotfound
}

class FirebaseStoreUser: ObservableObject {
    let db = Firestore.firestore().collection("users")
    let currentUser = Auth.auth().currentUser
    @Published var getAttributesSet: Bool?
    
    init() {
        Task {
            await self.setAttributesExist()
        }
    }
    
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
    
   func setAttributesExist() async {
            do {
                let user = try self.getUserID()
                    let document = try await self.db.document("\(user)").getDocument()
                self.getAttributesSet = document.exists
                }
        catch {
            self.getAttributesSet = false
            }
        }
    }

class CalculateBMI {
    
    let doc = FirebaseStoreUser()
    var attributesList: [String: Any] = [:]
    var getResults: Double = 0
    var errorReturn: String = ""
    
    init() {
        Task{
            do { 
                try await setBMI()
            } catch {
                errorReturn = "something went wrong"
            }
        }
    }
    
    
    func setBMI() async throws ->  (String, Double, Double, String, Double) {
        guard let attributes = try await doc.getData()
        else {
            throw RetrieveDataErrors.attributesError
        }
        
        for (key, value) in attributes {
            attributesList.updateValue(value, forKey: key)
        }

        guard let stringHeight = attributesList["height"] as? String,
              let stringGender = attributesList["gender"] as? String,
              let stringAge = attributesList["age"] as? String,
              let reduction = attributesList["reduction"] as? String,
              let stringWeight = attributesList["weight"] as? String else {
            throw RetrieveDataErrors.attributesError
        }
        
        guard let height = Double(stringHeight),
              let weight = Double(stringWeight),
              let reduction = Double(reduction)
        else {
            throw RetrieveDataErrors.attributesError
        }
        
        getResults = weight / height
        
        return (stringGender, weight, height, stringAge, reduction)
    }
}

enum RetrieveDataErrors: Error {
    case attributesError
}

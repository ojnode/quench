//
//  backend.swift
//  quench
//
//  Created by prince ojinnaka on 19/06/2024.
//

import FirebaseFirestore
import FirebaseAuth

struct storeAttributes {
    var userKey = ""
    var userValue = ""
    var firebase = FirebaseStoreUser()
    
    func storeData()  async -> [String] {
        var errorList = [String]()
        var userID = ""
        do {
            userID = try firebase.getUserID()
        } catch {
            errorList.append("Something went wrong")
        }
        
        let docRef = firebase.db.document(userID)
        
        do {
            try await valueValidation(key: "\(userKey)", value: "\(userValue)")
        } catch let error as storageValidation {
            if case let .incorrectValue(string) = error {
                errorList.append(string)
            }
            return errorList
        } catch {
            errorList.append("Something went wrong")
            return errorList
        }
        
        do {
            try await docRef.updateData(["\(userKey)": "\(userValue)"])
        } catch {
            errorList.append(error.localizedDescription)
            return errorList
        }
        return errorList
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
                DispatchQueue.main.async { // REMOVED WARNING DUE TO PUBLISHED VARIABLE CHNAGES NOT OCCURING ON MAIN THREAD
                    self.getAttributesSet = document.exists
                    }
                }
        catch {
            DispatchQueue.main.async {
                self.getAttributesSet = false
                }
            }
        }
}

class AccessUserAttributes: ObservableObject {
    @Published var userAttributes: [String:Any] = [:]
    let firebase = FirebaseStoreUser()
    var errorReturn: String = ""
    var attributesKeys: [String] = []
    
    init() {
        Task{
            do {
                try await displayAttributes()
            } catch {
                errorReturn = "something went wrong"
            }
        }
    }
    
    func displayAttributes() async throws {
        guard let retrievedAttributes = try await firebase.getData()
        else {
            throw RetrieveDataErrors.attributesError
        }
        DispatchQueue.main.async {
            self.userAttributes = retrievedAttributes
            self.attributesKeys = ["Age", "Height", "Weight", "Gender", "Reduction Goal (%)"]
        }
    }
}

enum RetrieveDataErrors: Error {
    case attributesError
}

func calculateAge(DOB: Date) -> Int? {
    let age = Calendar.current.dateComponents([.year], from: DOB,
                                        to: Date())
                                 .year
    return age
}

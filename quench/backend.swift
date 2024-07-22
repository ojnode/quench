//
//  backend.swift
//  quench
//
//  Created by prince ojinnaka on 19/06/2024.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

struct storeAttributes {
    var userKey: String
    var userValue: String
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

func createDatabase(data: [String: String]) async throws {
    let db = FirebaseStoreUser().db
    let user = try FirebaseStoreUser().getUserID()
    try await db.document(user).setData(data)
}

func valueValidation(key: String, value: String) async throws -> Double {
    if key != "Gender" {
        guard let doublevalue = Double(value) else {
            throw storageValidation.incorrectValue("invalid \(key) input")
        }
        
        if doublevalue < 0 {
            throw storageValidation.incorrectValue("invalid \(key) input")
        }
        
        return doublevalue
    }
    return 0.0
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
// return error and  display later 
class AccessUserAttributes: ObservableObject {
    @Published var userAttributes: [String:Any] = [:]
    let firebase = FirebaseStoreUser()
    var errorReturn: String = ""
    var attributesKeys: [String] = []
    @Published var BMI: Double = 0.0
    
    init() {
        Task{
            do {
                try await displayAttributes()
                calculateBodyMassIndex()
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
    
    func calculateBodyMassIndex() {
        if let anyWeight = userAttributes["Weight"] as? String,
           let weight = Double(anyWeight),
           let anyHeight = userAttributes["Height"] as? String,
           let height = Double(anyHeight), height > 0 {
            BMI = weight / (height * height)
        } else {
            BMI = 0
        }
    }
}

struct unitsPerDrink {
    var unitsPerDrinkArray = [
        "Single small shot of spirits* (25ml, ABV 40%)" : 1,
        "Alcopop (275ml, ABV 5.5%)" : 1.5,
        "Small glass of red/white/rosé wine (125ml, ABV 12%)" : 1.5,
        "Bottle of lager/beer/cider (5%) 330ml" : 1.7,
        "Can of lager/beer/cider (440ml, ABV 5.5%)" : 2.4,
        "Pint of lower-strength lager/beer/cider (ABV 3.6%)" : 2,
        "Standard glass of red/white/rosé wine (175ml, ABV 12%)" : 2.1,
        "Pint of higher-strength lager/beer/cider (ABV 5.2%) ": 3,
        "Large glass of red/white/rosé wine (250ml, ABV 12%) ": 3
        ]
}

class unitCalculator: ObservableObject {
    var userUnitsPerDrink: [String: Double] = [:]
    @Published var totalUnits: Double = 0.0
    let userDrinks = UserDefaults.standard
    
    func individualWeeklyUnits(drinkType: String, userUnitsPerWeek: Double) {
        let drinkInformation = unitsPerDrink().unitsPerDrinkArray
        if let unitsperDrink = drinkInformation[drinkType] {
            userUnitsPerDrink[drinkType] = unitsperDrink * userUnitsPerWeek
        }
        saveuserUnitsPerDrink()
        calculateTotalUnits()
    }
    
    func saveuserUnitsPerDrink() {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userUnitsPerDrink, options: .prettyPrinted)
            userDrinks.set(jsonData, forKey: "drinks")
        } catch {
            print("e no work")
        }
    }
    
    func calculateTotalUnits() {
        totalUnits = 0.0
        guard let userData = userDrinks.data(forKey: "drinks") else {
            return
        }
        
        do {
            let savedDrinks = try JSONSerialization.jsonObject(with: userData, options: [])
            guard let convertedSavedDrinks = savedDrinks as? [String: Double] else {
                return
            }
            
            for (_, units) in convertedSavedDrinks {
                totalUnits += units
            }
        } catch {
            print("e no work")
        }
    }
}

enum RetrieveDataErrors: Error {
    case attributesError
}

func calculateAge(DOB: Date) -> Int {
    let age = Calendar.current.dateComponents([.year], from: DOB,
                                        to: Date())
                                 .year
    return age ?? 0
}

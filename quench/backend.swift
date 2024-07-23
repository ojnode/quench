//
//  backend.swift
//  quench
//
//  Created by prince ojinnaka on 19/06/2024.
//

import FirebaseFirestore
import Firebase
import FirebaseAuth
import Combine
import SQLite

struct storeAttributes {
    var userKey: String
    var userValue: String
    
    func storeData()  async -> [String] {
        let firebase = FirebaseStoreUser()
        var errorList = [String]()
        let userID = userID().getUserID()
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

struct storeSubstanceIntakeOnline {
    var substanceType: String
    var substanceAmount: [String: Double]
    let firebase = FirebaseStoreUser()
    
    func storedata() async -> String? {
        
        let userID = userID().getUserID()
        let docRef = firebase.db.document(userID)
        
        do {
            try await docRef.updateData(["\(substanceType)": "\(substanceAmount)"])
        } catch {
            return "something went wrong" // handle error better later
        }
        return nil
    }
    
}

struct userID {
    let firebase = FirebaseStoreUser()
    
    func getUserID() -> String {
        var userID = ""
        do {
            userID = try firebase.getUserID()
        } catch {
            return "something went wrong" // handle error better later
        }
        return userID
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

enum userIDErrors: Error {
    case IDnotfound
}

class FirebaseStoreUser: ObservableObject {
    let db = Firestore.firestore().collection("users") // 
    let currentUser = Auth.auth().currentUser
    @Published var checkAttributesSet: Bool?
    
    init() {
        Task {
            await self.setAttributes()
        }
    }
    
    func getUserID() throws -> String {
        guard let user = currentUser?.uid else {
            throw userIDErrors.IDnotfound
        }
        return user
    }
    
    func getData() async throws -> [String :Any]? {
        let docRef = db.document(try self.getUserID())
        let doc = try await docRef.getDocument().data()
        return doc
    }
    
   func setAttributes() async {
            do {
                let user = try self.getUserID()
                let document = try await self.db.document("\(user)").getDocument()
                DispatchQueue.main.async { // REMOVED WARNING DUE TO PUBLISHED VARIABLE CHNAGES NOT OCCURING ON MAIN THREAD
                    self.checkAttributesSet = document.exists
                    }
                }
        catch {
            DispatchQueue.main.async {
                self.checkAttributesSet = false
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
        Task {
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
    let unitsPerDrinkArray = [
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

class userIntakeStorage: ObservableObject {
    var userUnitsPerDrink: [String: Double] = [:]
    
    func userWeeklyIntake(drinkType: String, userUnitsPerWeek: Double) {
        let drinkInformation = unitsPerDrink().unitsPerDrinkArray
        if let unitsperDrink = drinkInformation[drinkType] {
            userUnitsPerDrink[drinkType] = unitsperDrink * userUnitsPerWeek
        }
    }
        
    func saveUserUnitsPerDrink() async {
        let substanceIntake = storeSubstanceIntakeOnline(substanceType: "alcohol", substanceAmount: userUnitsPerDrink)
        await substanceIntake.storedata()
    }
}

class localStorage: userIntakeStorage {
    var rowIDs = [Int64]()
    @Published var totalUnits: Double = 0.0
    let user: Table
    let db: Connection
    
    var unitTotalCalculator: getTotalUnits?
    
    override init() {
        user = Table("\(userID().getUserID())")
        
        do {
            db = try Connection(retrieveDatabasePath().path)
        } catch {
            fatalError("Unable to open database connection: \(error)")
        }
    }
    
    func saveData() async -> String? {
        do {
            try db.run(user.drop(ifExists: true))
            let db = try Connection(retrieveDatabasePath().path)
            let id = Expression<Int>("id")
            let drinkName = Expression<String>("drinkName")
            let units = Expression<Double>("units")
            
            try db.run(user.create() { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(drinkName)
                t.column(units)
            })
            
            for (drink, drinkUnit) in userUnitsPerDrink {
                print("during insertion \(drink)")
                let rowID = try db.run(user.insert(drinkName <- drink, units <- drinkUnit))
                rowIDs.append(rowID)
            }
            
            unitTotalCalculator = getTotalUnits(dataBase: db, savedDrinks: user)
            totalUnits = try await unitTotalCalculator?.getTotalUnits() ?? 0
            
            saveTotalUnits()
            
        } catch {
            return "something went wrong"
        }
        userUnitsPerDrink = [:]
        return nil
    }
    
    // for learning purpose, yes I can just save total to mySQL
    private func saveTotalUnits() {
        UserDefaults.standard.set(totalUnits, forKey: "totalUnits")
    }
}

class getTotalUnits: ObservableObject {
    let dataBase: Connection
    let savedDrinks: Table
    let units = Expression<Double>("units")
    var totalUnits = 0.0
    
    init(dataBase: Connection, savedDrinks: Table) {
        self.dataBase = dataBase
        self.savedDrinks = savedDrinks
    }
    
    func getTotalUnits() async throws -> Double {
        
        do {
            for user in try dataBase.prepare(savedDrinks) {
                totalUnits += user[units]
                print(user)
            }
        } catch {
            throw RetrieveDataErrors.unitsError
        }
        
        return totalUnits
    }
}

enum RetrieveDataErrors: Error {
    case attributesError
    case unitsError
}

func calculateAge(DOB: Date) -> Int {
    let age = Calendar.current.dateComponents([.year], from: DOB,
                                        to: Date())
                                 .year
    return age ?? 0
}

func retrieveDatabasePath() -> URL {
    let fileManager = FileManager.default
    let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    let databaseURL = applicationSupportDirectory.appendingPathComponent("myDatabase.sqlite")
    
    return databaseURL
}

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
    let defaults = UserDefaults.standard
    
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
        
        do {  // repeating code refactor later
            if defaults.bool(forKey: "isAttributesSet") {
                try await docRef.updateData(["\(userKey)": "\(userValue)"])
            } else {
                try await docRef.setData(["\(userKey)": "\(userValue)"])
            }
        } catch {
            errorList.append(error.localizedDescription)
            return errorList
        }
        return errorList
    }
}

struct storeSubstanceIntakeOnline {
    var substanceType: String
    var onlineTotal: Double
    let firebase = FirebaseStoreUser()
    let defaults = UserDefaults.standard
    
    func storedata() async -> String? {
        let userID = userID().getUserID()
        let docRef = firebase.db.document(userID)
        
        do { // repeating code refactor later
            if defaults.bool(forKey: "isAttributesSet") {
                try await docRef.updateData(["\(substanceType)": "\(onlineTotal)"])
            } else {
                try await docRef.setData(["\(substanceType)": "\(onlineTotal)"])
            }
        } catch {
            return "something went wrong" // handle error better later
        }
        return nil
    }
}

class userProgress {
    let previousUnits = UserDefaults.standard.double(forKey: "previousTotalUnits")
    let currentTotalUnits = UserDefaults.standard.double(forKey: "totalUnits")
    let reductionPercentage = UserDefaults.standard.double(forKey: "reduction") / 100

    func calculateUnitsGoal() -> Double {
        let userUnitsReductionGaol = reductionPercentage * previousUnits
        return userUnitsReductionGaol
    }
    
    func userPrecentageAchieved() -> Double {
        let changeInUnits = currentTotalUnits - previousUnits
        let  precentageAchieved = (changeInUnits / previousUnits) * 100
        return precentageAchieved
    }
    
    func checkReductionIncrease() -> Bool {
        if self.userPrecentageAchieved() < 0 {
            return true
        }
        return false
    }
    
    func  percentageDifference() -> Bool {
        if abs(self.userPrecentageAchieved()) > self.reductionPercentage {
            return true
        }
        return false
    }
    
    func displayResuls() -> String {
        if  self.checkReductionIncrease() && self.percentageDifference() {
            return "Decreased by \(abs(self.userPrecentageAchieved())). Goal achieved."
        }
        
        if self.checkReductionIncrease() && !self.percentageDifference() {
            return "Decreased by \(abs(self.userPrecentageAchieved())). Goal not achieved."
        }
        
        return "Increased by \(self.userPrecentageAchieved()). Goal not achieved."
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

class FirebaseStoreUser {
    let db = Firestore.firestore().collection("users") //
    let currentUser = Auth.auth().currentUser
    
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
}

class checkUserAttrubutes {
    let db = Firestore.firestore().collection("users") //
    let currentUser = Auth.auth().currentUser
    let defaults = UserDefaults.standard
    
    func saveCheckSetAttributes() async {
        do {
            let user = try FirebaseStoreUser().getUserID()
            let document = try await self.db.document("\(user)").getDocument()
            DispatchQueue.main.async { // REMOVED WARNING DUE TO PUBLISHED VARIABLE CHNAGES NOT OCCURING ON MAIN THREAD
                self.defaults.set(document.exists, forKey: "isAttributesSet")
            }
        }
        catch {
            DispatchQueue.main.async {
                self.defaults.set(false, forKey: "isAttributesSet")
            }
        }
    }
}

// return error and  display later
class AccessUserAttributes: ObservableObject {
    @Published var userAttributes: [String:Any] = [:]
    let firebase = FirebaseStoreUser()
    var errorReturn: String = ""
    var attributesKeys: [String] = ["Age", "Height", "Weight",
                                    "Gender", "Reduction Goal (%)"]
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
            self.userAttributes = retrievedAttributes
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

class userIntakeUpdate: ObservableObject {
    var userUnitsPerDrink: [String: Double] = [:]
    
    func userWeeklyIntake(drinkType: String, userUnitsPerWeek: Double) {
        let drinkInformation = unitsPerDrink().unitsPerDrinkArray
        if let unitsperDrink = drinkInformation[drinkType] {
            userUnitsPerDrink[drinkType] = unitsperDrink * userUnitsPerWeek
        }
    }
}

class intakeStorage: userIntakeUpdate {
    var rowIDs = [Int64]()
    @Published var totalUnits: Double = 0.0
    let user = Table("\(userID().getUserID())")
    let db: Connection
    
    var unitTotalCalculator: getTotalUnits?
    
    override init() {
        do {
            db = try Connection(retrieveDatabasePath().path)
        } catch {
            fatalError("Unable to open database connection: \(error)")
        }
    }
    
    // totally unnecessary just learning mySQL
    func saveData() async -> String? {
        do {
            UserDefaults.standard.set(UserDefaults.standard.double(forKey: "totalUnits"), forKey: "previousTotalUnits")
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
                let rowID = try db.run(user.insert(drinkName <- drink, units <- drinkUnit))
                rowIDs.append(rowID)
            }
            
            unitTotalCalculator = getTotalUnits(dataBase: db, savedDrinks: user)
            totalUnits = try await unitTotalCalculator?.getTotalUnits() ?? 0
            
            
            let substanceIntake = storeSubstanceIntakeOnline(substanceType: "alcohol", onlineTotal: totalUnits)
            await substanceIntake.storedata()
            UserDefaults.standard.set(totalUnits, forKey: "totalUnits")
            
        } catch {
            return "something went wrong"
        }
        userUnitsPerDrink = [:]
        return nil
    }
}

func setDefaultsFirstLogin() async throws {
    let firebase = FirebaseStoreUser()
    guard let retrievedAttributes = try await firebase.getData()
    else {
        throw RetrieveDataErrors.attributesError
    }
    if let anyReduction = retrievedAttributes["Reduction Goal (%)"] as? String,
       let reduction = Double(anyReduction),
       let anyTotalUnits = retrievedAttributes["alcohol"] as? String,
       let totalUnits = Double(anyTotalUnits) {
        UserDefaults.standard.set(reduction, forKey: "reduction")
        UserDefaults.standard.set(totalUnits, forKey: "totalUnits")
    } else {
        throw RetrieveDataErrors.attributesError
    }
    
}

class getTotalUnits {
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

func resetLocalStorage() -> String? {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    
    do {
        let db = try Connection(retrieveDatabasePath().path)
        let user = Table("\(userID().getUserID())")
        try db.run(user.drop(ifExists: true))
        
        for (key, _) in dictionary {
            defaults.removeObject(forKey: key)
        }
        
    } catch {
        return "something went wrong"
    }
    return nil
}

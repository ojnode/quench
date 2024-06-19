//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


// use a calculator for age later

struct SetGoal: View {
    @State var age = ""
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    @State var reduction: Double = 0
    @State var errors = [String]()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack (spacing:20) {
                CreateText(label: "Quench", size: 25)
                Spacer()
                
                VStack (spacing: 30) {
                    CreateEntryField(label: "Age:", text: $age)
                    CreateEntryField(label: "Weight:", text: $weight)
                    CreateEntryField(label: "Height:", text: $height)
                    CreateEntryField(label: "Gender:", text: $gender)
                    
                    VStack {
                        CreateText(label: "Percentage Reduction Goal", size: 18)
                        Slider(value: $reduction, in:0...100)
                        CreateText(label: String(format: "%.2f%%", reduction), size: 20)
                    }
                    
                }
                Spacer()
                
                VStack(spacing: 5) {
                    ForEach(errors, id: \.self) { errorMessage in
                        CreateText(label: errorMessage, size: 15, color: .red)
                    }
                }
                
                Button(action: {
                    Task
                    {await errors = storeAttributes(age: age, weight: weight,
                                           height: height, gender: gender, reduction: reduction).storeData()
                        hideKeyboard()
                    }
                }, label: {
                    Text("Set Goal")
                })
                .buttonStyle(AllButtonStyle())
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    SetGoal()
        .modelContainer(for: Item.self, inMemory: true)
}

struct CreateEntryField: View {
    var label: String
    var text: Binding<String>
    var secure: Bool = false
    
    var body: some View {
        
        HStack {
            CreateText(label: label, size: 20, weight: .medium)
            if !(secure) {
                CreateTextField(text: "Enter your \(label)", inputText: text)
            } else { CreateSecureField(text: "Enter your \(label)", inputText: text)
            }
        }
    }
}

struct storeAttributes  {
    var age: String
    var weight: String
    var height: String
    var gender: String
    var reduction: Double
    
    func storeData() async -> [String] {
        var errorList = [String]()
        let stringReduction = String(format:"%.2f%", reduction)
        let data: [String: String] = ["age": age, "weight": weight,
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
        return errorList
        }
}


enum storageValidation: Error {
    case errorAddingDocument(String)
    case incorrectValue(String)
}

func createDatabase(data: [String: String]) async throws {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    try await db.collection("users").document((user!.uid)).setData(data)
}

func valueValidation(key: String, value: String) async throws -> Double {
    guard let doublevalue = Double(value) else {
        throw storageValidation.incorrectValue("invalid \(key) input")
    }
    
    if doublevalue < 1 {
        throw storageValidation.incorrectValue("invalid \(key) input")
    }
    
    return doublevalue
}

//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SetGoal: View {
    @State var age = ""
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    @State var reduction: Double = 0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack (spacing:70) {
                CreateText(label: "Quench", size: 25)
                
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
                
                Button(action: {
                    Task
                    {await storeAttributes(age: age, weight: weight,
                                           height: height, gender: gender).storeData()
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
    
    func storeData() async {
        //catch all errors for value and show at once later
        
        var data: [String: String] = ["age": age, "weight": weight, "height": height, "gender": gender]
        
        do {
            for (key, value) in data {
                if key != "gender" {
                    try await valueValidation(input: key)
                }
            }
            try await createDatabase(data: data)
        }
        catch let error as storageValidation {
                print("\(error)")
        } catch {
            print("unkown")
        }
    }
}

enum storageValidation: Error {
    case errorAddingDocument(String)
    case incorrectValue(String)
}

func createDatabase(data: [String: String]) async throws {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    do {
        try await db.collection("users").document((user!.uid)).setData(data)
    } catch {
            throw storageValidation.errorAddingDocument("Something went wrong")
        }
}

func valueValidation (input: String) async throws -> Double {
    guard let doublevalue = Double(input) else {
        throw storageValidation.incorrectValue("invalid \(input) input")
    }
    return doublevalue
}

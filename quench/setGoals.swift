//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//

import SwiftUI

struct SetGoal: View {
    @State var age = ""
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    @State var reduction: Double = 0
    @State var errors = [String]()
    @State var birthDate = Date.now
    var BMIClass = CalculateBMI()
    @State var shouldPresentSheet: editChoice? = nil
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack (spacing:50) {
                VStack{
                    CreateText(label: "Quench", size: 25)
                }
                Spacer()
                
                VStack(spacing: 70) {
                    HStack {
                        CreateText(label: "Height: \(height)", size: 20, color: .black)
                        Button(action: {shouldPresentSheet = .sheetA}, label: {
                            Text("Edit")
                                .frame(maxWidth: .infinity)
                                .frame(height: 40) // Adjust height of the button
                                .foregroundColor(.black) // Text color
                                .background(Color.blue) // Button background color
                                .cornerRadius(10)
                        })
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
                    
                    HStack {
                        CreateText(label: "Weight: \(weight)", size: 20, color: .black)
                        Button("edit") {
                            shouldPresentSheet = .sheetB
                        }
                        .buttonStyle(AllButtonStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .buttonStyle(AllButtonStyle())
                    
                    HStack {
                        CreateText(label: "Age: \(age)", size: 20, color: .black)
                        Button("edit") {
                            print("edit")
                        }
                        .buttonStyle(AllButtonStyle())
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .buttonStyle(AllButtonStyle())
                    
                    HStack {
                        CreateText(label: "Reduction goal: \(String(reduction))", size: 20, color: .black)
                        Button("edit") {
                            print("huh")
                        }
                        .buttonStyle(AllButtonStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .buttonStyle(AllButtonStyle())
                    
                    Spacer()
                }
            }
        }
        .onAppear() {
            Task {
                gender = try await BMIClass.setBMI().0
                weight = try await String(BMIClass.setBMI().1)
                height = try await String(BMIClass.setBMI().2)
                age = try await String(BMIClass.setBMI().3)
                reduction = try await BMIClass.setBMI().4
            }
        }
        .sheet(item: $shouldPresentSheet) { sheet in
            switch sheet {
            case .sheetA:
                editWindow(attribute: "Height", attributeValue: "\(height)")
            case .sheetB:
                editWindow(attribute: "Weight", attributeValue: "\(weight)")
            }
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
            } else { 
                CreateSecureField(text: "Enter your \(label)", inputText: text)
            }
        }
    }
}

struct editWindow: View {
    
    @State var attribute: String
    @State var attributeValue: String
    @State var errors = [String]()
    
    var body: some View {
        ZStack{
            VStack {
                CreateEntryField(label: "\(attribute)", text: $attributeValue)
                
                Button(action: {
                    Task {
                        errors = await storeAttributes(userKey: "\(attribute)", userValue: "\(attributeValue)").storeData()
                        hideKeyboard()
                    }
                }, label: {
                    Text("Set Goal")
                })
                .buttonStyle(AllButtonStyle())
            }
            
            VStack(spacing: 5) {
                ForEach(errors, id: \.self) { errorMessage in
                    CreateText(label: errorMessage, size: 15, color: .red)
                }
            }
            
        }
        
    }
}

enum editChoice: String, Identifiable {
    case sheetA, sheetB
    var id: String {
        return self.rawValue
    }
}


//
//                VStack (spacing: 30) {
//                    DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
//                        Text("Date of Birth")
//                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                    }
//                    .accentColor(.blue)
//                    CreateEntryField(label: "Weight:", text: $weight)
//                    CreateEntryField(label: "Height:", text: $height)
//                    CreateEntryField(label: "Gender:", text: $gender)
//
//                    VStack {
//                        CreateText(label: "Percentage Reduction Goal", size: 18)
//                        Slider(value: $reduction, in:0...100)
//                        CreateText(label: String(format: "%.2f%%", reduction), size: 20)
//                    }
//
//                }

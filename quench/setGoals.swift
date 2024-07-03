//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//

import SwiftUI

struct SetGoal: View {
    @State var reduction: Double = 0
    @State var errors = [String]()
    @State var birthDate = Date.now
    @State var shouldPresentSheet: EditChoice? = nil
    @StateObject var BMIClass = AccessUserAttributes()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack (spacing:30) {
                VStack{
                    CreateText(label: "Quench", size: 25)
                }
                Spacer()
                
                VStack(spacing:60) {
                    ForEach(BMIClass.attributesKeys.indices, id: \.self) { index in
                        let key = BMIClass.attributesKeys[index]
                        
                        HStack {
                            if let value = BMIClass.userAttributes[key] {
                                CreateText(label: "\(key): \(value)", size: 20, color: .black)
                            } else {
                                CreateText(label: "\(key): not set", size: 20, color: .black)
                            }
                            Button(action: {shouldPresentSheet = EditChoice.allCases[index]}, label: {
                                Text("Update")
                                    .frame(width: 70, height: 30)
                                    .foregroundColor(.blue)
                                    .background(Color.black)
                                    .cornerRadius(10)
                            })
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .buttonStyle(AllButtonStyle())
                    }
                }
                Spacer()
            }
        
            .sheet(item: $shouldPresentSheet) { sheet in
                switch sheet {
                case .sheetA:
                    updateAttributeWindow(attribute: "\(BMIClass.attributesKeys[0])", shouldPresentSheet: $shouldPresentSheet)
                case .sheetB:
                    updateAttributeWindow(attribute: "\(BMIClass.attributesKeys[1])", shouldPresentSheet: $shouldPresentSheet)
                case .sheetC:
                    updateAttributeWindow(attribute: "\(BMIClass.attributesKeys[2])", shouldPresentSheet: $shouldPresentSheet)
                case .sheetD:
                    updateAttributeWindow(attribute: "\(BMIClass.attributesKeys[3])", shouldPresentSheet: $shouldPresentSheet)
                case .sheetE:
                    updateAttributeWindow(attribute: "\(BMIClass.attributesKeys[4])", shouldPresentSheet: $shouldPresentSheet)
                }
            }
            .onChange(of: shouldPresentSheet) {
                Task {
                    try await BMIClass.displayAttributes()
                }
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

struct updateAttributeWindow: View {
    @State var attribute: String
    @State var attributeValue: String = ""
    @State var errors = [String]()
    @Binding var shouldPresentSheet: EditChoice?
    @State var birthDate: Date = Date()
    @State var reduction = 0.0
    
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                VStack {
                    if "\(attribute)" == "Age" {
                        DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Date of Birth")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .onChange(of: birthDate) {
                                    attributeValue = String(calculateAge(DOB: birthDate) ?? 0)
                                }
                        }  
                    } else if "\(attribute)" == "Reduction Goal (%)" {
                        CreateText(label: "Percentage Reduction Goal", size: 18)
                        Slider(value: $reduction, in:0...100)
                        CreateText(label: String(format: "%.2f%%", reduction), size: 20)
                            .onChange(of: reduction) {
                                attributeValue = String(format: "%.2f%", reduction)
                            }
                    } else {
                        CreateEntryField(label: "\(attribute)", text: $attributeValue)
                    }
                    
                    Button(action: {
                        Task {
                            errors = await storeAttributes(userKey: "\(attribute)", userValue: attributeValue).storeData()
                            if errors.isEmpty {
                                shouldPresentSheet = nil
                                hideKeyboard()
                            }
                            
                        }
                    }, label: {
                        Text("Save")
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
}

enum EditChoice: String, CaseIterable, Identifiable {
    case sheetA, sheetB, sheetC, sheetD, sheetE
    var id: String {
        return self.rawValue
    }
}

//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//

import SwiftUI

// use a calculator for age later

struct SetGoal: View {
    @State var age = ""
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    @State var reduction: Double = 0
    @State var errors = [String]()
    @State var birthDate = Date.now

    var body: some View {
        ZStack {
//            Color.black
//                .ignoresSafeArea()
            
            VStack (spacing:20) {
                CreateText(label: "Quench", size: 25)
                Spacer()
                
                // change color of text
                VStack (spacing: 30) {
                    DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date ")
                    }
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
            } else { 
                CreateSecureField(text: "Enter your \(label)", inputText: text)
            }
        }
    }
}

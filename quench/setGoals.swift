//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//


import SwiftUI

struct SetGoal: View {
    
    @State var age: String = ""
    @State var weight: String = ""
    @State var height: String = ""
    @State var sex: String = ""
    
    var body: some View {
        ZStack {
            VStack (spacing: 30) {
                
                HStack {
                    Text("Age")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$age)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                HStack {
                    Text("Weight")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$weight)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                HStack {
                    Text("Height")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$height)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                HStack {
                    Text("Sex")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$sex)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    SetGoal()
        .modelContainer(for: Item.self, inMemory: true)
}

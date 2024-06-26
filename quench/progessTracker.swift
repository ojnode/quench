//
//  SwiftUIView.swift
//  quench
//
//  Created by prince ojinnaka on 18/06/2024.
//

import SwiftUI
import Charts

struct ProgressTracker: View {
    @State var BMIResults = CalculateBMI()
    @State var signedOut = false
    
    var data = [ 
        BMICategory(range: 18.5, category: "underweight"),
        BMICategory(range: 24.9, category: "healthy range"),
        BMICategory(range: 29.9, category: "overweight"),
        BMICategory(range: 39.9, category: "obesity"),
        BMICategory(range: 40, category: "Severe Obesity")
    ]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    CreateText(label: "Quench", size: 60, weight: .medium)
                    CreateText(label: "One day at a time", size: 20, design: .serif)
                }
                
                Spacer()
                VStack{
                    HStack(spacing:200) {
                        CreateImageView(image: "bmi", width: 1, height: 1,
                                        radius: 10, frameWidth: 60, frameHeight: 150)
                        CreateText(label: "BMI", size: 25, weight: .bold, color: .black)
                    }
                    CreateText(label: String(BMIResults.BMIResults), size: 35,
                               weight: .semibold, color: .red)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                
                Chart {
                    
                    ForEach (data) { d in
                        
                        BarMark(x: PlottableValue.value("category", d.category),
                                y: PlottableValue.value("range", d.range))
                        
                        
                    }
                }
                .padding()
                
                VStack {
                    HStack(spacing:200) {
                        CreateImageView(image: "bmi", width: 2, height: 1,
                                        radius: 30, frameWidth: 60, frameHeight: 100)
                        CreateText(label: "BMI", size: 25, weight: .light, color: .black)
                    }
                    CreateText(label: String(BMIResults.BMIResults), size: 35,
                               weight: .bold, color: .black)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                
                Button(action: {AuthService.shared.signOut(); signedOut = true}, label: {
                    Text("Sign out")
                })
                .navigationDestination(isPresented: $signedOut) {
                    ContentView()
                }
                .buttonStyle(AllButtonStyle())
            
            }
        }
    }
}

#Preview {
    ProgressTracker()
}

struct BMICategory: Identifiable {
    
    var id = UUID().uuidString
    var range: Double
    var category:String
}

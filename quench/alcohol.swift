//
//  SwiftUIView.swift
//  quench
//
//  Created by prince ojinnaka on 08/07/2024.
//

import SwiftUI

struct AlcoholUnits: View {
    @State var amountDrink: [String: Double] = [:]
    @EnvironmentObject var units: localStorage
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing:10) {
                VStack {
                    CreateText(label: "Quench", size: 40, weight: .medium)
                    CreateText(label: "One day at a time", size: 20, design: .serif)
                }
                Spacer()
                
                ScrollView {
                    VStack(spacing:20) {
                        ForEach(unitsPerDrink().unitsPerDrinkArray.sorted(by: >), id: \.key) { key, value in // use sorted by to convert dictionary to an array of tuples,
                            VStack(spacing:10) {
                                CreateText(label: key, size: 18)
                                VStack {
                                    CreateText(label: "Drinks per week", size: 12)
                                    Slider(
                                        value: Binding(
                                            get: { amountDrink[key] ?? 0.0},
                                            set: { newValue in
                                                amountDrink[key] = newValue
                                                units.userWeeklyIntake(drinkType: key, userUnitsPerWeek: newValue)
                                            }
                                    ), in:0...50, 
                                        step: 1
                                    )
                                    CreateText(label: String(format: "%.0f%", amountDrink[key] ?? 0), size: 15)
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    AlcoholUnits()
}

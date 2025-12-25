//
//  AddBudgetScreen.swift
//  BudgetApp
//
//  Created by Горніч Антон on 25.12.2025.
//

import SwiftUI

struct AddBudgetScreen: View {
    
    @State private var title: String = ""
    @State private var limit: Double?
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && limit != nil && Double(limit!) > 0
    }
    
    var body: some View {
        Form{
            Text("New Budget")
                .font(.title)
                .font(.headline)
            
            TextField("Title", text: $title)
                .presentationDetents([.medium])
            
            TextField("Title", value: $limit, format: .number)
                .keyboardType(.numberPad)
            
            Button{
                //
            }label:{
                Text("save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            
        }.presentationDetents([.medium])
    }
    
}

#Preview {
    AddBudgetScreen()
}

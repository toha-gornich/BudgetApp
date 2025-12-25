//
//  BudgetListScreen.swift
//  BudgetApp
//
//  Created by Горніч Антон on 25.12.2025.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.navigationTitle("Budget App")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Budget"){
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented, content: {
                AddBudgetScreen()
            })
    }
}

#Preview {
    NavigationStack{
        BudgetListScreen()
    }
}

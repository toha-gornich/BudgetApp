//
//  EditExpenseScreen.swift
//  BudgetApp
//
//  Created by Горніч Антон on 18.01.2026.
//

import SwiftUI

struct EditExpenseScreen: View {
    
    let expense: Expense
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


struct EditExpenseContainerView: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View {
        NavigationStack{
            EditExpenseScreen(expense: expenses[0])
        }
    }
}

#Preview {
    EditExpenseContainerView()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}

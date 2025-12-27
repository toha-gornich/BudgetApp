//
//  ExpenseCellVIew.swift
//  BudgetApp
//
//  Created by Горніч Антон on 27.12.2025.
//

import SwiftUI

struct ExpenseCellView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.title ?? "")
            Spacer()
            Text(expense.amount, format: .currency(code:Locale.currencyCode))
        }
    }
}
struct ExpenseCellViewContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View {
        ExpenseCellView(expense: expenses[0])
    }
}

#Preview {
    ExpenseCellViewContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}

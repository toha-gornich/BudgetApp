//
//  AddBudgetScreen.swift
//  BudgetApp
//
//  Created by Горніч Антон on 25.12.2025.
//

import SwiftUI

struct AddBudgetScreen: View {
    
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var title: String = ""
    @State private var limit: Double?
    @State private var errorMessage: String = ""
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && limit != nil && Double(limit!) > 0
    }
    
    private func saveBudget(){
        let budget = Budget(context: context)
        budget.title = title
        budget.limit = limit ?? 0.0
        budget.dateCreated = Date()
        
        do{
            try context.save()
            errorMessage = ""
        }catch{
            errorMessage = "Unable to save budget"
        }
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
                if Budget.exists(context: context, title: title){
                    saveBudget()
                }else {
                    errorMessage = "Budget title already exists."
                }
            }label:{
                Text("save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            Text(errorMessage)
            
        }.presentationDetents([.medium])
    }
    
}

#Preview {
    AddBudgetScreen()
        .environment(\.managedObjectContext, CoreDataProvider(inMemory: true).context)
}

//
//  BudgetDetailScreen.swift
//  BudgetApp
//
//  Created by Горніч Антон on 27.12.2025.
//

import SwiftUI
import CoreData


struct EditExpenseConfig: Identifiable {
    var id = UUID()
    var expense: Expense
    let childContext: NSManagedObjectContext
//    context is parant context
    init?( expenseObjectID: NSManagedObjectID, context: NSManagedObjectContext){
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = context
        guard let existingExpense = self.childContext.object(with: expenseObjectID) as? Expense else{
            return nil
        }
        self.expense = existingExpense
    }
}

struct BudgetDetailScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    
    let budget: Budget
    
    @State private var title: String = ""
    @State private var amount: Double?
    @State private var quantity: Int?
    
    @State private var selectedTags: Set<Tag> = []
    
    @State private var editExpenseConfig: EditExpenseConfig?
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    init(budget: Budget) {
        
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty && quantity != nil && Int(quantity!) > 0
    }
    
    private var total: Double {
        return expenses.reduce(0) { result, expense in
            expense.amount + result
        }
    }
    
    private var remaining: Double {
        budget.limit - total
    }
    
    private func addExpense() {
        
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        
        budget.addToExpenses(expense)
        
        do {
            try context.save()
            title = ""
            quantity = nil
            amount = nil
            selectedTags = []
            
        } catch {
            context.rollback()
            print(error.localizedDescription)
        }
        
    }
    
    private func deleteExpense(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        VStack {
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        
        Form {
            
            Section("New expense") {
                TextField("Title", text: $title)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                TextField("Quantity", value: $quantity, format: .number)
                
                TagsView(selectedTags: $selectedTags)
                
                Button(action: {
                    addExpense()
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
            }
            
            Section("Expenses") {
                  
                List {
                    
                    VStack {
                        HStack {
                            Spacer()
                            Text("Total")
                            Text(total, format: .currency(code: Locale.currencyCode))
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("Remaining")
                            Text(remaining, format: .currency(code: Locale.currencyCode))
                                .foregroundStyle(remaining < 0 ? .red: .green)
                            Spacer()
                        }
                    }
                    
                    ForEach(expenses) { expense in
                        ExpenseCellView(expense: expense)
                            .onLongPressGesture{
//                                expenseToEdit = expense
                                editExpenseConfig = EditExpenseConfig(expenseObjectID: expense.objectID, context: context )
                            }
                    }.onDelete(perform: deleteExpense)
                }
                
            }
                        
        }.navigationTitle(budget.title ?? "")
            
            .sheet(item: $editExpenseConfig){editExpenseConfig in
                NavigationStack{
                    EditExpenseScreen(expense: editExpenseConfig.expense){
                        do {
                            try context.save()
                            self.editExpenseConfig = nil
                        }catch {
                            print(error)
                        }
                    }
                        .environment(\.managedObjectContext, editExpenseConfig.childContext)
                }
            }

    }
}


struct BudgetDetailScreenContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View {
        BudgetDetailScreen(budget: budgets.first(where: { $0.title == "Groceries"})!)
    }
}

#Preview {
    NavigationStack {
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}



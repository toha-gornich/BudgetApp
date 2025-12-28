//
//  FilterSreeen.swift
//  BudgetApp
//
//  Created by Горніч Антон on 28.12.2025.
//

import SwiftUI

struct FilterScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var filteredExpenses: [Expense] = []
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    @State private var title: String = ""
    
    private func filterTags() {
        
        if selectedTags.isEmpty {
            return
        }
        
        let selectedTagNames = selectedTags.map{ $0.name}
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
        do{
            filteredExpenses = try context.fetch(request)
        }catch {
            print(error)
        }
        
    }
    
    private func filteredByPrice() {
        
        guard let startPrice = startPrice,
              let endPrice = endPrice else {return}
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format:"amount >= %@ AND amount <= %@", NSNumber(value: startPrice), NSNumber(value: endPrice))
        
        do{
            filteredExpenses = try context.fetch(request)
        }catch {
            print(error)
        }
    }
    
    private func filteredByTitle() {
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        
        do{
            filteredExpenses = try context.fetch(request)
        }catch {
            print(error)
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Section("Filter by Tags"){
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, filterTags)
            }
            Section("Filter by Price"){
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search"){
                    filteredByPrice()
                }
            }
            Section("Filter by Title"){
                TextField("STitle", text: $title)
                Button("Search"){
                    filteredByTitle()
                }
            }
            
            List(filteredExpenses){expense in
                ExpenseCellView(expense: expense)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Show All"){
                    selectedTags = []
//                    selectedTags =
                    filteredExpenses = expenses.map{$0}
                }
                Spacer()
            }
            
        }.padding()
        .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack{
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

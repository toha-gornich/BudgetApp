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
    
    var body: some View {
        VStack(alignment: .leading){
            Section("Filter by Tags"){
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, filterTags)
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

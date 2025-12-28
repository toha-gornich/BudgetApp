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
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedSortOptions: SortOptions? = nil
    @State private var selectedSortDirections: SortDirection = .asc
    
    private enum SortDirection: CaseIterable, Identifiable{
        case asc
        case desc
        
        var id: SortDirection { self }
        
        var title:String{
            switch self{
            case .asc:
                return "Ascending"
            case .desc:
                return "Descending"
                
            }
        }
    }
    
    private enum SortOptions:CaseIterable, Identifiable {
        case title
        case date
        
        var id: SortOptions { self }
        
        var title:String{
            switch self{
            case .title:
                return "Title"
            case .date:
                return "Date"
                
            }
        }
        
        var key:String{
            switch self{
            case .title:
                return "title"
            case .date:
                return "dateCreated"
                
            }
        }
    }
    
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
    
    private func filteredByDate() {
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        
        do{
            filteredExpenses = try context.fetch(request)
        }catch {
            print(error)
        }
    }
    
    private func performSort(){
        guard let sortOption = selectedSortOptions else {return}
        
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirections == .asc ? true : false)]
        
        do{
            filteredExpenses = try context.fetch(request)
        }catch {
            print(error)
        }
    }
    
    var body: some View {
        List{
            Section("Sort"){
                Picker("Sort Options", selection: $selectedSortOptions){
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortOptions.allCases){
                        option in
                        Text(option.title)
                            .tag(Optional(option))
                    }
                }
                
                Picker("Sort Direction", selection: $selectedSortDirections){
                    ForEach(SortDirection.allCases){option in
                        Text(option.title)
                            .tag(option)
                    }
                    
                }
                Button("Sort"){
                    performSort()
                }.buttonStyle(.borderless)
            }
            
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
            Section("Filter by Date"){
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                
                Button("Search"){
                    filteredByDate()
                }
            }
            Section("Expenses"){
                ForEach(filteredExpenses){expense in
                    ExpenseCellView(expense: expense)
                }
            }
            
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

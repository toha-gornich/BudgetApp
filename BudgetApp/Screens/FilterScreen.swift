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
    
    @State private var selectedFilterOption: FilterOption? = nil
    
    private enum FilterOption: Identifiable, Equatable {
        
        case none
        case byTags(Set<Tag>)
        case byPriceRange(minPrice: Double, maxPrice: Double)
        case byTitle(String)
        case byDate(startDate: Date, endDate: Date)
        
        var id: String {
            switch self {
            case .none:
                return "none"
            case .byTags:
                return "byTags"
            case .byPriceRange:
                return "byPriceRange"
            case .byTitle:
                return "byTitle"
            case .byDate:
                return "byDate"
            }
        }
    }
    
    private enum SortDirection: CaseIterable, Identifiable {
        case asc
        case desc
        
        var id: SortDirection { self }
        
        var title: String {
            switch self {
            case .asc:
                return "Ascending"
            case .desc:
                return "Descending"
            }
        }
    }
    
    private enum SortOptions: String, CaseIterable, Identifiable {
        case title = "title"
        case date = "dateCreated"
        
        var id: SortOptions { self }
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .date:
                return "Date"
            }
        }
        
        var key: String {
            rawValue
        }
    }
    
    // Об'єднана функція для фільтрації та сортування
    private func performFilterAndSort() {
        let request = Expense.fetchRequest()
        
        // Встановлюємо предикат для фільтрації
        if let selectedFilterOption = selectedFilterOption {
            switch selectedFilterOption {
            case .none:
                request.predicate = NSPredicate(value: true)
            case .byPriceRange(let minPrice, let maxPrice):
                request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: minPrice), NSNumber(value: maxPrice))
            case .byTitle(let title):
                request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
            case .byDate(let startDate, let endDate):
                request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
            case .byTags(let tags):
                let tagNames = tags.map { $0.name }
                request.predicate = NSPredicate(format: "ANY tags.name IN %@", tagNames)
            }
        }
        
        // Встановлюємо сортування
        if let sortOption = selectedSortOptions {
            request.sortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirections == .asc)]
        }
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        List {
            Section("Sort") {
                Picker("Sort Options", selection: $selectedSortOptions) {
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortOptions.allCases) { option in
                        Text(option.title)
                            .tag(Optional(option))
                    }
                }
                
                Picker("Sort Direction", selection: $selectedSortDirections) {
                    ForEach(SortDirection.allCases) { option in
                        Text(option.title)
                            .tag(option)
                    }
                }
                
                Button("Sort") {
                    performFilterAndSort()
                }.buttonStyle(.borderless)
            }
            
            Section("Filter by Tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags) {
                        selectedFilterOption = .byTags(selectedTags)
                    }
            }
            
            Section("Filter by Price") {
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search") {
                    guard let startPrice = startPrice,
                          let endPrice = endPrice else { return }
                    selectedFilterOption = .byPriceRange(minPrice: startPrice, maxPrice: endPrice)
                }
            }
            
            Section("Filter by Title") {
                TextField("Title", text: $title)
                Button("Search") {
                    selectedFilterOption = .byTitle(title)
                }
            }
            
            Section("Filter by Date") {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                
                Button("Search") {
                    selectedFilterOption = .byDate(startDate: startDate, endDate: endDate)
                }
            }
            
            Section("Expenses") {
                ForEach(filteredExpenses) { expense in
                    ExpenseCellView(expense: expense)
                }
            }
            
            HStack {
                Spacer()
                Button("Show All") {
                    selectedFilterOption = FilterOption.none
                }
                Spacer()
            }
        }
        .onChange(of: selectedFilterOption) {
            performFilterAndSort()
        }
        .onChange(of: selectedSortDirections) {
            performFilterAndSort()
        }
        .padding()
        .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack {
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

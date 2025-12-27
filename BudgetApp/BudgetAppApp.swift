//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Горніч Антон on 25.12.2025.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    let provider: CoreDataProvider
    let tagSeeder: TagsSeeder
    
    init(){
        provider = CoreDataProvider()
        tagSeeder = TagsSeeder(context: provider.context)
    }
    
    

    var body: some Scene {
        WindowGroup {
            BudgetListScreen()
                .onAppear{
                    let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeededData")
                    
                    if !hasSeededData{
                        
                        let commonTags = ["Food","Dining","Travel","Entertainment","Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
                        do{
                            try tagSeeder.seed(commonTags)
                        }catch{
                            print(error)
                        }
                        
                        UserDefaults.standard.setValue(true, forKey: "hasSeededData")
                    }
                }
                .environment(\.managedObjectContext, provider.context)
        }
    }
}

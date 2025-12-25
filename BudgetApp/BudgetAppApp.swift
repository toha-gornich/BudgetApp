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
    
    init(){
        provider = CoreDataProvider()
    }
    
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, provider.context)
        }
    }
}

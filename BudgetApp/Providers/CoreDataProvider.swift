//
//  CoreDataProvider.swift
//  BudgetApp
//
//  Created by Горніч Антон on 25.12.2025.
//

import Foundation
import CoreData

class CoreDataProvider{
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(inMemory: Bool = false){
        persistentContainer = NSPersistentContainer(name: "BudgetAppModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores{_, error in
            if let error{
                fatalError("Core Data store failed to init \(error)")
            }
        }
    }
    
}

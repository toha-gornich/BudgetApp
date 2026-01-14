//
//  Expense+Extentions.swift
//  BudgetApp
//
//  Created by Горніч Антон on 14.01.2026.
//

import Foundation
import CoreData

extension Expense {
    
    var total: Double {
        amount * Double(quantity)
    }
}

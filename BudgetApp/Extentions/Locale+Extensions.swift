//
//  Locale+Extensions.swift
//  BudgetApp
//
//  Created by Горніч Антон on 27.12.2025.
//

import Foundation


extension Locale{
    
    static var currencyCode:String {
        
        Locale.current.currency?.identifier ?? "UAH"
    }
}

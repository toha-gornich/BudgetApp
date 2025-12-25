//
//  String+Extentions.swift
//  BudgetApp
//
//  Created by Горніч Антон on 25.12.2025.
//

import Foundation


extension String{
    
    var isEmptyOrWhitespace: Bool{
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

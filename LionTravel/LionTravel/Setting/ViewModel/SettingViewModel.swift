//
//  SettingViewModel.swift
//  LionTravel
//
//  Created by Logan on 2024/5/14.
//

import Foundation

class SettingViewModel {
    
    // Sample data for the collection view
    var items: [String] = ["Item 001", "Item 002", "Item 003", "Item 004", "Item 005",
                           "Item 006", "Item 007", "Item 008", "Item 009", "Item 010",
                           "Item 011", "Item 012", "Item 013", "Item 014", "Item 015",
                           "Item 016", "Item 017", "Item 018", "Item 019", "Item 020",
                           "Item 021", "Item 022", "Item 023", "Item 024"]
    
//    var items: [String] = ["Item 001", "Item 002", "Item 003", "Item 004", "Item 005", "Item 006"]
    
    
    // Return the number of items
    func numberOfItems() -> Int {
        return items.count
    }
    
    // Return a specific item
    func item(at index: Int) -> String {
        return items[index]
    }
    
    
}

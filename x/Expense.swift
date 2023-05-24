//
//  Wydatki.swift
//  GM
//
//  Created by Jakub Górka on 10/10/2022.
//

import Foundation
import Firebase

class Expense: ObservableObject, Identifiable{
    @Published var id: String
    @Published var title: String
    @Published var cost: String
    @Published var signature: String
    
    init(id: String, title: String, cost: String, signature: String) {
        
        self.id = id
        self.title = title
        self.cost = cost
        self.signature = signature
    }
}

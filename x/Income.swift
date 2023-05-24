//
//  Wydatki.swift
//  GM
//
//  Created by Jakub Górka on 10/10/2022.
//

import Foundation
import Firebase

class Income: ObservableObject, Identifiable{
    @Published var id: String
    @Published var title: String
    @Published var amount: String
    @Published var signature: String

    
    init(id: String, title: String, amount: String, signature: String) {
        
        self.id = id
        self.title = title
        self.amount = amount
        self.signature = signature
    }
    
}

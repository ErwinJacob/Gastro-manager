//
//  User.swift
//  x
//
//  Created by Jakub Górka on 25/10/2022.
//

import Foundation
import Firebase

class User: ObservableObject, Identifiable{
    
    @Published var login: String
    @Published var password: String
    @Published var name: String
    @Published var role: String

    //Init blank user for login purpose
    init(){
        self.login = ""
        self.password = ""
        self.name = ""
        self.role = ""
    }
    
    
    //Init used for fetching data from DB
    init(login: String, password: String, name: String, role: String){
        self.login = login
        self.password = password
        self.name = name //Displayed signature name
        self.role = role //User - read only; Bar; Admin
    }
    
    
//    _ completion: @escaping (Bool) -> Void
    func login(login: String, password: String, _ completion: @escaping (Bool) -> Void){
        
        let db = Firestore.firestore()
        
        let ref = db.collection("Users")
        
        ref.whereField("login", isEqualTo: login).whereField("password", isEqualTo: password).getDocuments { snapshot, error in
            if snapshot != nil && error == nil{
                for user in snapshot!.documents{
                    print("Found: \(user["name"] as? String ?? "blank name?")")
                    
                    self.login = user["login"] as? String ?? "blank login?"
                    self.password = user["password"] as? String ?? "blank password?"
                    self.name = user["name"] as? String ?? "blank name?"
                    self.role = user["role"] as? String ?? "blank role?"
                    
                }
                completion(true)
            }
            else{
                print("ERROR, while searching for user: \(String(describing: error))")
            }
        }
        
    }
    
}

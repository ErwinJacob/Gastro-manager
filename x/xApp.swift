//
//  xApp.swift
//  x
//
//  Created by Jakub Górka on 23/10/2022.
//

import SwiftUI
import Firebase

@main
struct xApp: App {
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//
//  LoginViewController.swift
//  x
//
//  Created by Jakub Górka on 24/10/2022.
//

import SwiftUI

struct LoginViewController: View {
    
    @ObservedObject var system: System
    @State var login: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack{
            
            if system.logged{
                ViewController(system: system)
            }
            if !system.logged{
                LoginView(system: system)
            }

        }
    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewController(system: System())
    }
}

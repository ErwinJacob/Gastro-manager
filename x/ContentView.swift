//
//  ContentView.swift
//  x
//
//  Created by Jakub Górka on 23/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var system: System = System()

    var body: some View {
        LoginViewController(system: system)
            .onAppear{
                system.fetchData()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

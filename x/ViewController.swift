//
//  ViewController.swift
//  x
//
//  Created by Jakub Górka on 23/10/2022.
//

import SwiftUI

struct ViewController: View {
    
    @ObservedObject var system: System
    
    var body: some View {
        
        VStack(spacing: 0){
         
            
            
            
            Spacer()
            
            if system.currentView == "Dzień"{
                DzienView(system: system)
            }
            if system.currentView == "Faktury"{
                FakturyView(system: system)
            }
            if system.currentView == "Grafik"{
                GrafikView()
            }
            
            Spacer()
            
            Divider()
            
            HStack(spacing: 0){
                
                Button {
                    system.changeView(viewName: "Dzień")
                } label: {
                    ZStack{
                        Rectangle()

                        Text("Dzień")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                
                Divider()
                
                Button {
                    system.changeView(viewName: "Faktury")
                } label: {
                    ZStack{
                        Rectangle()
                            
                        Text("Faktury")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                
                Divider()
                
                Button {
                    system.changeView(viewName: "Grafik")
                } label: {
                    ZStack{
                        Rectangle()

                        Text("Grafik")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                

                
                
            }
            
            .frame(height: 60)
            
        }
        .ignoresSafeArea()
        
    }
        
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController(system: System())
    }
}

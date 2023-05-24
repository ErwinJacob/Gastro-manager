//
//  View2.swift
//  x
//
//  Created by Jakub Górka on 23/10/2022.
//

import SwiftUI

struct FakturyView: View {
    
//    @ObservedObject var system: System
    
    @State var showAddFirmAlert: Bool = false
    @State var firmName: String = ""
    
    var body: some View {
        NavigationView{

            VStack{
                
                HStack{
                    
                    Text("Faktury")
                        .bold()
                        .font(.title)
                    
                    
                    //Przycisk dodawania firmy
                    
                    Spacer()
                    
                    Button {
                        
                        showAddFirmAlert = true
                        firmName = ""
                        
                    } label: {
                        Text("Dodaj firme")
                            .bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    .alert("Dodaj nową firme", isPresented: $showAddFirmAlert) {
                        TextField("Nazwa firmy", text: $firmName)
                        
                        
                        
                        Button("Add"){

                            system.addFirm(firmName: firmName)
                            
                        }
                        Button("Cancel"){
                            showAddFirmAlert = false
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.top, 40)
                
                
                
                ForEach(system.faktury){ firm in
                    
                    NavigationLink {
                        FakturyFirmView(firm: firm, signature: system.user.name)
                            
                    } label: {
                        
                        
                        
                        if firm.countNotpaidFV() == 0{
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(Color.blue.opacity(0.5))

                                Text(firm.nazwaFirmy)
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            }
                                .frame(width: 300, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            
                            
                        }
                        else{
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(Color.red.opacity(0.5))

                                VStack{
                                    Text(firm.nazwaFirmy)
                                        .bold()
                                        .font(.title3)
                                    
                                    Text("Liczba niezapłaconych faktur: \(firm.countNotpaidFV())")
                                }
                            }
                            .frame(width: 300, height: 60)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                            
                        }
                        
                    }
                    .padding(.bottom, 5)
                    
                }
                
                Spacer()

            }
                
            
        }
    }
}


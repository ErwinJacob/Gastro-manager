//
//  FakturaView.swift
//  x
//
//  Created by Jakub Górka on 18/11/2022.
//

import SwiftUI

struct FakturaView: View {
    
    @ObservedObject var faktura: Faktura
    @ObservedObject var firm: Faktury
    @State var color: Color
    
    @State private var expandView: Bool = false
    
    @State private var showDelRaportConfirmationAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                                
                VStack(alignment: .leading){
                    HStack{
                        Text("Numer faktury: ")
                            .bold()
                        Text(faktura.nrFaktury)
                    }
                    
                    HStack{
                        Text("Kwota: ")
                            .bold()
                        Text("\(checkAndConvertString(inString: faktura.kwota))zł")
                    }
                    
                    HStack{
                        Text("Data wystawienia: ")
                            .bold()
                        Text(faktura.dataFaktury)
                    }
                    
                    HStack{
                        Text("Termin płatnosci: ")
                            .bold()
                        Text(faktura.terminPlatnosci)
                    }
                    
                    if faktura.notatka != ""{
                        Text("Notatka:")
                            .bold()
                        Text(faktura.notatka)
                    }
                    
                }
                
                Spacer()
                
                Button {
                    showDelRaportConfirmationAlert = true
                } label: {
                    Image(systemName: "trash.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(color)
                }
                .confirmationDialog("Are you sure?",
                                    isPresented: $showDelRaportConfirmationAlert) {
                    Button("Delete", role: .destructive) {
                        faktura.delData(firmName: firm.nazwaFirmy)
                        firm.fetchData()
                    }
                } message: {
                    Text("You cannot undo this action")
                }
                
                Button {
                    
                    if faktura.zaplacona{
//                        color = Color.red
                        faktura.changeFaktura(firm: firm.nazwaFirmy, zaplacona: false)
                        firm.fetchData()
                    }
                    else {
//                        color = Color.green
                        faktura.changeFaktura(firm: firm.nazwaFirmy, zaplacona: true)
                        firm.fetchData()
                    }
                    
                } label: {
                    if faktura.zaplacona{
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(color)
                    }
                    else{
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(color)
                    }
                }
                
            }
            
            if expandView{
                VStack{
                    Text(":)")
                        .frame(height: 100)
                }
            }
            
            HStack(){
//                Spacer()
                
                VStack{
                    //empty stack
                }
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    expandView.toggle()
                } label: {
                    
                    if !expandView{
                        VStack{
                            Text("Rozwiń")
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(color)
                        .padding(0)
                    }
                    else{
                        VStack{
                            Image(systemName: "chevron.up")
                            Text("Zwiń")
                        }
                        .foregroundColor(color)
                        .padding(0)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                

                Text(faktura.signature)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.footnote)
                    
            }

            
        }
        .padding(.all, 15)
//        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(color, lineWidth: 2)
        )
        
    }
}


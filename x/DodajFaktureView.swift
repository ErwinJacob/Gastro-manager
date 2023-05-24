//
//  DodajFaktureView.swift
//  x
//
//  Created by Jakub Górka on 20/11/2022.
//

import SwiftUI

struct MultilineTextField: View {
    @Binding var note: String
    var body: some View {
        TextField("Address", text: $note, axis: .vertical)
            .lineLimit(3)
            .textFieldStyle(.roundedBorder)
//            .padding()
    }
}

struct DodajFaktureView: View {

    @Binding var isPresented: Bool
    
    @ObservedObject var firm: Faktury
    @State var signature: String
    
    @State var dataFaktury = ""
    @State var kwota = ""
    @State var notatka = ""
    @State var nrFaktury = ""
    @State var photoPath = ""
    @State var terminPlatnosci = ""
    @State var zaplacone = false
    
    @State private var dateDataWystawienia = Date()
    @State private var dateTerminPlatnosci = Date()


    
    var body: some View {
        VStack(){
            
            VStack{
                
                Text("Numer faktury:")
                    .bold()
                    .font(.title3)
                TextField("Numer faktury", text: $nrFaktury)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
                
                
                Text("Kwota:")
                    .bold()
                    .font(.title3)
                TextField("Kwota", text: $kwota)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
                
                                
                DatePicker(
                    "Data wystawienia faktury:",
                    selection: $dateDataWystawienia,
                    displayedComponents: [.date]
                )
                .environment(\.locale, Locale.init(identifier: "pl"))
                .padding(.bottom, 20)


                DatePicker(
                    "Termin płatności:",
                    selection: $dateTerminPlatnosci,
                    displayedComponents: [.date]
                )
                .environment(\.locale, Locale.init(identifier: "pl"))
                .padding(.bottom, 20)

                Text("Notatka:")
                    .bold()
                    .font(.title3)
                
                MultilineTextField(note: $notatka)
                            
            }
            .padding(.horizontal, 30)
            
            
            
            
            Button("Dodaj"){
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                formatter.calendar = Calendar(identifier: .gregorian)
                
                firm.addData(dataFaktury: formatter.string(from: dateDataWystawienia), kwota: checkAndConvertString(inString: kwota), notatka: notatka, nrFaktury: nrFaktury, photoPath: photoPath, signature: signature, terminPlatnosci: formatter.string(from: dateTerminPlatnosci), zaplacona: zaplacone)
                
                isPresented = false
                
                
            }
            
        }
    }
}


//
//  LoginView.swift
//  x
//
//  Created by Jakub Górka on 24/10/2022.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var system: System

    @State var login: String = "kuba"
    @State var password: String = "gorka"
    
    var body: some View {
        VStack{
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding(.top, 80)
            
            Spacer()
            
            TextField("Login", text: $login)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 50)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 50)
                
            Button{
                //check password
                system.user.login(login: login, password: password) { ready in
                    if ready{
                        if system.user.name != ""{
                            system.logged = true                            
                        }
                    }
                }
                login = ""
                password = ""
                                
                //adding current day if doesnt exist
//                system.addDay(newDay: Day()) //now doing that while fetching data

            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.green)
                        .frame(width: 170, height: 45)
                    Text("Login")
                        .bold()
                        .foregroundColor(.white)
                    
                }
            }
            .padding(.top, 20)
//            .padding(.bottom, 100)
            
            Spacer()
            
            VStack(spacing: 20){
                Text("TODO LIST:")
                    .bold()
                    .font(.title)
                VStack{
                    Text("sprawdzamy poprawnosc stringa, wrzucamy jako string to db")
                        .foregroundColor(.green)
                    Text(" -> Operujemy na stringu, w razie potrzeby edycji konwertujemy do floata")
                        .foregroundColor(.green)

                }
                VStack(spacing: 0){
                    Text("Blokada edycji dnia, jeżeli to nie dziś")
                    Text("Funkcje sprawdzającą string z liczba")
                        .foregroundColor(.green)
                    Text(" -> Zamiana przecinka na kropke")
                        .foregroundColor(.green)
                    Text("G,G0,KP,KW,T,U zmiana z numeric na String w DB")
                        .foregroundColor(.green)
                    Text("Wyswietlanie raportow")
                        .foregroundColor(.green)
                    Text("Podpisy pod raportami, wyplatami, wplatami")
                    
                    Text("Rejestr czasu pracy")
                    Text("Podglad swojego czasu pracy dla usera,")
                    Text("bar widzi i moze edytowac czasy wszystkich")
                    Text("Raporty miesieczne")
                }
                VStack(spacing: 0){
                    Text("Ekran admina")
                    Text(" -> Dodawanie uzytkownikow")
                    Text(" -> Dodawanie grafiku")
                        
                    Text("Grafik")
                        .padding(.top, 10)
                    Text(" -> Mozliwosc zmiany")

                    Text("Rejestr faktur")
                        .padding(.top, 10)
                        .foregroundColor(.green)
                    Text(" -> Podział na firmy")
                        .foregroundColor(.green)
                    Text(" -> Przypomnienie o terminie płatnosci")
                }
            }
            
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(system: System())
    }
}

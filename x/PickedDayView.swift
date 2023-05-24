//
//  PickedDayView.swift
//  x
//
//  Created by Jakub Górka on 24/10/2022.
//

import SwiftUI

struct PickedDayView: View {

    @ObservedObject var day: Day
    @ObservedObject var user: User
    
    @State var showAddExpenseAlert: Bool = false
    @State var expenseTitle: String = ""
    @State var expenseCost: String = ""
    
    @State var showAddIncomeAlert: Bool = false
    @State var incomeTitle: String = "Rozpoczecie dnia"
    @State var incomeAmount: String = ""
    
    @State var showExpensesSheet = false
    @State var showIncomesSheet = false
    
    @State var showDelRaportConfirmationAlert = false

    @State var showAddRaportAlert = false
    @State var raportUtarg: String = ""
    @State var raportT: String = ""
    @State var raportG0: String = ""
    @State var raportG: String = ""
    
    var body: some View {
        VStack(spacing: 0){
            
            Text(day.date)
                .padding(.top, 60)
                .font(.title3)
                .bold()
            
            Spacer()

            HStack{
                Text("Raporty:")
                    .bold()
                    .font(.title)
                    .foregroundColor(.blue)
                Spacer()
                Button {
                    //add raport
                    showAddRaportAlert = true
                } label: {
//                    Image(systemName: "plus.circle")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(.blue)
                    Text("Dodaj raport")
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 2)
//                            Capsule(style: .continuous)
//                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, dash: [10]))
                        )
                }
                .alert("Add new raport", isPresented: $showAddRaportAlert) {
                    TextField("Utarg", text: $raportUtarg)
                        .keyboardType(.decimalPad)
                    TextField("D", text: $raportG0)
                        .keyboardType(.decimalPad)
                    TextField("Terminal", text: $raportT)
                        .keyboardType(.decimalPad)
                    TextField("Gotówka", text: $raportG)
                        .keyboardType(.decimalPad)

                    Button("Add"){
                        day.addRaport(signature: user.name, utarg: raportUtarg
                                      , G0: raportG0,
                                      G: raportG,
                                      T: raportT)
                        raportUtarg = ""
                        raportG0 = ""
                        raportT = ""
                        raportG = ""
                    }
                    Button("Cancel"){
                        raportUtarg = ""
                        raportG0 = ""
                        raportT = ""
                        raportG = ""
                        showAddExpenseAlert = false
                    }
                    
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
                
            ScrollView{
                ForEach(day.raports){ raport in
                    ZStack{
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text("Utarg: \(raport.utarg)zł")
                                Text("D: \(raport.G0)zł")
                                Text("Terminal: \(raport.T)zł")
                                Text("Gotowka: \(raport.G)zł")
                            }
                            
                            Spacer()
                            VStack(alignment: .trailing){
                                HStack{
                                    
                                    Button {
                                        day.editDay(utarg: raport.utarg, G: raport.G, G0: raport.G0, T: raport.T, finalRaportId: raport.id)
                                        day.fetchDayData()
                                    } label: {

                                        if day.finalRaportId != raport.id{
                                            Text("Raport końcowy?")
//                                                .bold()
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.blue, lineWidth: 2)
                                                )
                                        }
                                        else{
                                            Text("Raport końcowy")
//                                                .bold()
                                                .foregroundColor(.green)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.green, lineWidth: 2)
                                                )
                                        }
                                    }
                                    
                                    Button {
                                        showDelRaportConfirmationAlert = true
                                    } label: {
                                        Image(systemName: "trash.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                Spacer()
                                Text(raport.signature)
                                Text(raport.time)
                            }
                            .font(.footnote)
                        }
                        .padding(.all, 20)
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .frame(height: 120)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .confirmationDialog("Are you sure?",
                                        isPresented: $showDelRaportConfirmationAlert) {
                        Button("Delete raport", role: .destructive) {
                            day.delRaport(docId: raport.id)
                            day.fetchRaports()
                        }
                    } message: {
                        Text("You cannot undo this action")
                    }
                }
            }
            Spacer()
            
            Button {
                showExpensesSheet = true
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                        .opacity(0.8)
                    HStack{
                        Text("Wydatki: \(day.KW)zł")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(width: 240, height: 60)
            }
            .padding(.bottom, 10)
            .sheet(isPresented: $showExpensesSheet) {
                List{
                    ForEach(day.expenses, id: \.self.id){ expense in
                        VStack{
                            HStack{
                                Text(expense.title)
                                Spacer()
                                Text("\(expense.cost)zł")
                            }
                            HStack{
                                Text(expense.signature)
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                        .swipeActions(allowsFullSwipe: true) {
                            Button{
                                day.delExpense(doc: expense)
                                day.fetchExpenses()
                            } label:{
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button("Add expense"){
                        //show alert
                        expenseCost = ""
                        expenseTitle = ""
                        showAddExpenseAlert = true
                    }
                    .bold()
                    .alert("Add new expense", isPresented: $showAddExpenseAlert) {
                        TextField("Title", text: $expenseTitle)
                        TextField("Cost", text: $expenseCost)
                            .keyboardType(.decimalPad)
                            
                        Button("Add"){
                            day.addExpense(title: expenseTitle, cost: expenseCost, signature: user.name)
                        }
                        Button("Cancel"){
                            showAddExpenseAlert = false
                        }
                        
                    }
                }
            }
            
            
            Button {
                showIncomesSheet = true
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                        .opacity(0.8)
                    HStack{
                        Text("Wpłaty: \(day.KP)zł")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(width: 240, height: 60)

            }
            .sheet(isPresented: $showIncomesSheet) {
                List{
                    ForEach(day.incomes, id: \.self.id){ income in
                        VStack{
                            HStack{
                                Text(income.title)
                                Spacer()
                                Text("\(income.amount)zł")
                            }
                            HStack{
                                Text(income.signature)
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                        .swipeActions(allowsFullSwipe: true) {
                            Button{
                                day.delIncome(doc: income)
                                day.fetchIncomes()
                            } label:{
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.red)
                        }
                    }
                    
                    Button("Add income"){
                        //show alert
                        incomeAmount = ""
                        incomeTitle = "Rozpoczecie dnia"
                        showAddIncomeAlert = true
                    }
                    .bold()
                    .alert("Add new income", isPresented: $showAddIncomeAlert) {
                        TextField("Title", text: $incomeTitle)
                        TextField("Cost", text: $incomeAmount)
                            .keyboardType(.decimalPad)
                        Button("Add"){
                            day.addIncome(title: incomeTitle, amount: incomeAmount, signature: user.name)
                        }
                        Button("Cancel"){
                            showAddIncomeAlert = false
                        }
                        
                    } message: {
                        //                    Text("idk")
                    }
                }
            }
        }
    }
}

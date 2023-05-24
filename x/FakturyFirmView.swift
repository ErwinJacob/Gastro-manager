



import SwiftUI

struct FakturyFirmView: View {
    
    @ObservedObject var firm: Faktury
    @State var signature: String
    
    @State var showAddFvSheet: Bool = false
    
    var body: some View {
        VStack{
            
            ScrollView{
                ForEach(firm.faktury.sorted(by: { one, two in
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    
                    let date1 = dateFormatter.date(from: one.dataFaktury)
                    let date2 = dateFormatter.date(from: two.dataFaktury)

                    return (date1! > date2!)
                })){ faktura in
                    
                    if faktura.zaplacona{
                        FakturaView(faktura: faktura, firm: firm, color: Color.green)
                            .padding(.bottom, 10)

                    }
                    else{
                        FakturaView(faktura: faktura, firm: firm, color: Color.red)
                            .padding(.bottom, 10)
                    }
                        
                }
                .padding(.horizontal, 20)
                
            }

            Spacer()
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    
                    showAddFvSheet = true
                    
                } label: {
                    Text("Dodaj fakture")
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .sheet(isPresented: $showAddFvSheet, onDismiss: {
                    showAddFvSheet = false
                } , content: {
                    
                    //view dodawania faktury
                    DodajFaktureView(isPresented: $showAddFvSheet, firm: firm, signature: signature)
                    
                })
            }
        }
        .navigationBarTitle(firm.nazwaFirmy)
        .navigationBarTitleDisplayMode(.large)
    }
}

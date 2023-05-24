
import Foundation
import Firebase

class Day: ObservableObject, Identifiable, Hashable{
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    @Published var id: String
    @Published var date: String
    @Published var utarg: String
    @Published var KP: String
    @Published var KW: String
    @Published var G: String
    @Published var G0: String
    @Published var T: String
    @Published var raports: [Raport] = []
    @Published var expenses: [Expense] = []
    @Published var incomes: [Income] = []
    
    @Published var finalRaportId: String

    //init used to load data from db
    init(date: String, id: String, utarg: String = "0", KP: String = "0", KW: String = "0", G: String = "0", G0: String = "0", T: String = "0", finalRaportId: String = "No final raport yet") {
        self.date = date
        self.utarg = utarg
        self.KP = KP
        self.KW = KW
        self.G = G
        self.G0 = G0
        self.T = T
        self.id = id
        self.finalRaportId = finalRaportId
        self.fetchRaports()
        self.fetchExpenses()
        self.fetchIncomes()
    }
    
    //init new Day
    init(){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)        
        self.date = formatter.string(from: date)

        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "dd-MM-yyyy"
        self.id = formatter.string(from: date)
        //self.id = date.formatted(date: .long, time: .omitted)

        
        self.utarg = "0"
        self.KP = "0"
        self.KW = "0"
        self.G = "0"
        self.G0 = "0"
        self.T = "0"
        self.finalRaportId = "No final raport yet"
    }
    
    func fetchDayData(){
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).getDocument { day, error in
            if day != nil && error == nil{
                self.date = day!["date"] as? String ?? "missing?"
                self.utarg = day!["utarg"] as? String ?? "0.00"
                self.KP = day!["KP"] as? String ?? "0.00"
                self.KW = day!["KW"] as? String ?? "0.00"
                self.G = day!["G"] as? String ?? "0.00"
                self.G0 = day!["G0"] as? String ?? "0.00"
                self.T = day!["T"] as? String ?? "0.00"
                self.finalRaportId = day!["finalRaportId"] as? String ?? "missing?"
            }
            else{
                print("ERROR, fetching day \(self.id) data - fetchDayData()")
            }
        }
    }
    
    func editDay(utarg: String? = nil, KP: String? = nil, KW: String? = nil, G: String? = nil, G0: String? = nil, T: String? = nil, finalRaportId: String? = nil){
        
        let db = Firestore.firestore()
        
        if finalRaportId != nil{
            db.collection("Days").document(self.id).setData([
                "finalRaportId": finalRaportId!
            ], merge: true)
        }
        
        if utarg != nil{
            db.collection("Days").document(self.id).setData([
                "utarg": checkAndConvertString(inString: utarg!)
            ], merge: true)
        }
        
        if KP != nil{
            db.collection("Days").document(self.id).setData([
                "KP": checkAndConvertString(inString: KP!)
            ], merge: true)
        }
        
        if KW != nil{
            db.collection("Days").document(self.id).setData([
                "KW": checkAndConvertString(inString: KW!)
            ], merge: true)
        }
        
        if G != nil{
            db.collection("Days").document(self.id).setData([
                "G": checkAndConvertString(inString: G!)
            ], merge: true)
        }
        
        if G0 != nil{
            db.collection("Days").document(self.id).setData([
                "G0": checkAndConvertString(inString: G0!)
            ], merge: true)
        }
        
        if T != nil{
            db.collection("Days").document(self.id).setData([
                "T": checkAndConvertString(inString: T!)
            ], merge: true)
        }
    }
    
    func isItToday() -> Bool{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        if self.date == formatter.string(from: date){
            return true
        }
        else{
            return false
        }
    }
    
    func addExpense(title: String, cost: String, signature: String){
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).collection("Expenses").addDocument(data: [
            "title": title,
            "cost": checkAndConvertString(inString: cost),
            "signature": signature
        ]) { error in
            if error == nil{
                print("Uploading new expense to DB completed")
                self.fetchExpenses()
            }
            else{
                print("ERROR, while adding new expense")
            }
        }
        
        let newExpense = Float(checkAndConvertString(inString: cost)) ?? 0
        
        print(newExpense)
        
        var newKW = Float(self.KW) ?? 0
        
        print(newKW)
        newKW += newExpense
        
        print(newKW)
        
        let rounded = round(newKW * 100) / 100
        self.KW = checkAndConvertString(inString: rounded.description)
        
        print(self.KW)
        self.editDay(KW: self.KW)
        
    }
    
    func delExpense(doc: Expense){
        
        let db = Firestore.firestore()
        
        db.document("Days/\(self.id)/Expenses/\(doc.id)").delete { error in
            if error == nil{
                print("Expense with id: \(doc.id) in \(self.id) deleted")
            }
            else{
                print("ERROR, while deleting expense with id: \(doc.id)")
            }
        }
        
        let value = Float(doc.cost) ?? 0
        var newKW = Float(self.KW) ?? 0
        newKW -= value
        
        let rounded = round(newKW * 100) / 100

        self.KW = checkAndConvertString(inString: rounded.description)
        self.editDay(KW: self.KW)
    }
    
    
    func addIncome(title: String, amount: String, signature: String){
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).collection("Incomes").addDocument(data: [
            "title": title,
            "amount": checkAndConvertString(inString: amount),
            "signature": signature
        ]) { error in
            if error == nil{
                print("Uploading new income to DB completed")
                self.fetchIncomes()
            }
            else{
                print("ERROR, while adding new income")
            }
        }
        
        let newIncome = Float(checkAndConvertString(inString: amount)) ?? 0
        var newKP = Float(self.KP) ?? 0
        newKP += newIncome
        
        let rounded = round(newKP * 100) / 100

        self.KP = checkAndConvertString(inString: rounded.description)
        self.editDay(KP: self.KP)
        
    }
    
    func delIncome(doc: Income){
        
        let db = Firestore.firestore()
        
        db.document("Days/\(self.id)/Incomes/\(doc.id)").delete { error in
            if error == nil{
                print("Expense with id: \(doc.id) in \(self.id) deleted")
            }
            else{
                print("ERROR, while deleting expense with id: \(doc.id)")
            }
        }
        
        let value = Float(doc.amount) ?? 0
        var newKP = Float(self.KP) ?? 0
        newKP -= value
        
        let rounded = round(newKP * 100) / 100

        self.KP = checkAndConvertString(inString: rounded.description)
        self.editDay(KP: self.KP)
    
    }
    
    func fetchIncomes(){
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).collection("Incomes").getDocuments { snapshot, error in
            if error == nil{
                DispatchQueue.main.async {
                    self.incomes = snapshot!.documents.map { income in
                        return Income(id: income.documentID,
                                      title: income["title"] as? String ?? "There should be title",
                                      amount: income["amount"] as? String ?? "0",
                                      signature: income["signature"] as? String ?? "Missing signature"
                        )
                    }
                }
            }
            else{
                print("ERROR, fetching Incomes documents from day \(self.date)")
            }
        }
    }
    
    func fetchExpenses(){
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).collection("Expenses").getDocuments { snapshot, error in
            if error == nil{
                DispatchQueue.main.async {
                    self.expenses = snapshot!.documents.map { expense in
                        return Expense(id: expense.documentID,
                                       title: expense["title"] as? String ?? "There should be title",
                                       cost: expense["cost"] as? String ?? "0",
                                       signature: expense["signature"] as? String ?? "Missing signature"
                        )
                    }
                }
            }
            else{
                print("ERROR, fetching Expenses documents from day \(self.date)")
            }
        }
    }
    
    func addRaport(signature: String, utarg: String, G0: String, G: String, T: String){
        let time = Date()
        
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).collection("Raports").addDocument(data: [
            "time": time.formatted(date: .omitted, time: .shortened),
            "signature": signature,
            "utarg": checkAndConvertString(inString: utarg),
            "G0": checkAndConvertString(inString: G0),
            "G": checkAndConvertString(inString: G),
            "T": checkAndConvertString(inString: T)
            
        ]) { error in
            if error == nil{
                print("Uploading new raport to DB completed")
                self.fetchRaports()
            }
            else{
                print("ERROR, while adding new raport")
            }
        }
    }
    
    func delRaport(docId: String){
        let db = Firestore.firestore()
        
        db.document("Days/\(self.id)/Raports/\(docId)").delete { error in
            if error == nil{
                print("Raport with id: \(docId) deleted")
            }
            else{
                print("ERROR, while deleting raport with id: \(docId)")
            }
        }

    }
    
    func fetchRaports(){
        let db = Firestore.firestore()
        
        db.collection("Days").document(self.id).collection("Raports").getDocuments { snapshot, error in
            if error == nil{
                DispatchQueue.main.async {
                    self.raports = snapshot!.documents.map { raport in
                        return Raport(id: raport.documentID,
                                      time: raport["time"] as? String ?? "missing time",
                                      signature: raport["signature"] as? String ?? "missing signature",
                                      utarg: raport["utarg"] as? String ?? "0.00",
                                      G: raport["G"] as? String ?? "0.00",
                                      G0: raport["G0"] as? String ?? "0.00",
                                      T: raport["T"] as? String ?? "0.00"
                        )
                    }
                }
            }
            else{
                print("ERROR, fetching Raport documents from day \(self.date)")
            }
        }

    }
    
    
}

    

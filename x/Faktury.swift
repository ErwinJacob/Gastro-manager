//
//  Faktury.swift
//  x
//
//  Created by Jakub Górka on 15/11/2022.
//

import Foundation
import Firebase

class Faktura: ObservableObject, Identifiable{
    
    @Published var id: String
    @Published var dataFaktury : String
    @Published var kwota : String
    @Published var notatka : String
    @Published var nrFaktury : String
    @Published var photoPath : String
    @Published var signature : String
    @Published var terminPlatnosci: String
    @Published var zaplacona: Bool

    init(dataFaktury: String, id: String, kwota: String, notatka: String, nrFaktury: String, photoPath: String, signature: String, terminPlatnosci: String, zaplacona: Bool) {
        self.id = id
        self.dataFaktury = dataFaktury
        self.kwota = kwota
        self.notatka = notatka
        self.nrFaktury = nrFaktury
        self.photoPath = photoPath
        self.signature = signature
        self.terminPlatnosci = terminPlatnosci
        self.zaplacona = zaplacona
    }
    
    
    func notatkaExist() -> Bool{
        if self.notatka == ""{
            return false
        }
        else{
            return true
        }
    }
    
    func delData(firmName: String){
        
        let db = Firestore.firestore()
        
        db.collection("Faktury").document(firmName).collection("Faktury").document(self.id).delete()
        
    }
    func changeFaktura(firm: String, dataFaktury: String? = nil, id: String? = nil, kwota: String? = nil, notatka: String? = nil, nrFaktury: String? = nil, photoPath: String? = nil, signature: String? = nil, terminPlatnosci: String? = nil, zaplacona: Bool? = nil){
        
        let db = Firestore.firestore()
        
        if dataFaktury != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "dataFaktury": dataFaktury!
            ], merge: true)
        }
        
        if kwota != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "kwota": kwota!
            ], merge: true)
        }
        
        if notatka != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "notatka": notatka!
            ], merge: true)
        }

        if nrFaktury != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "nrFaktury": nrFaktury!
            ], merge: true)
        }

        if photoPath != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "photoPath": photoPath!
            ], merge: true)
        }

        if signature != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "signature": signature!
            ], merge: true)
        }

        if terminPlatnosci != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "terminPlatnosci": terminPlatnosci!
            ], merge: true)
        }

        if zaplacona != nil{
            db.collection("Faktury").document(firm).collection("Faktury").document(self.id).setData([
                "zaplacona": zaplacona!
            ], merge: true)
        }

    }
    
}

class Faktury: ObservableObject, Identifiable{
    
    
    @Published var nazwaFirmy: String
    @Published var faktury: [Faktura] = []
    
    init(nazwaFirmy: String) {
        self.nazwaFirmy = nazwaFirmy
        self.fetchData()
    }
    
    
//    func sortFVs(){
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//
//        var sortedArr: [Faktura] = []
//        
//        for date in self.faktury{
//            if sortedArr.isEmpty{
//                sortedArr.append(date)
//            }
//            else{
//                for (index, sortedData) in sortedArr.enumerated(){
//                    
//                    let dateOne = dateFormatter.date(from: date.dataFaktury)
//                    let dateTwo = dateFormatter.date(from: sortedData.dataFaktury)
//
//                    if dateTwo! > dateOne!{
//                        sortedArr.insert(date, at: index)
//                        break
//                    }
//                    
//                }
//                
//                self.faktury = sortedArr
//            }
//        }
//        
//
//    }
    
    func countNotpaidFV() -> Int{
        
        var counter = 0
        
        for faktura in self.faktury{
            if faktura.zaplacona == false{
                counter += 1
            }
        }
        
        return counter
        
    }

    
    func addData(dataFaktury: String, kwota: String, notatka: String, nrFaktury: String, photoPath: String, signature: String, terminPlatnosci: String, zaplacona: Bool){
        
        let db = Firestore.firestore()
        
        db.collection("Faktury").document(self.nazwaFirmy).collection("Faktury").addDocument(data: [
            "dataFaktury": dataFaktury,
            "kwota": kwota,
            "notatka": notatka,
            "nrFaktury": nrFaktury,
            "photoPath": photoPath,
            "signature": signature,
            "terminPlatnosci": terminPlatnosci,
            "zaplacona": zaplacona
        ])
        
        self.fetchData()
    }
    
    func fetchData(){
        
        let db = Firestore.firestore()
        
        db.collection("Faktury").document(self.nazwaFirmy).collection("Faktury").getDocuments { snapshot, error in
            if snapshot != nil && error == nil{
                DispatchQueue.main.async {
                    self.faktury = snapshot!.documents.map{ faktura in
                        return(Faktura(dataFaktury: faktura["dataFaktury"] as? String ?? "",
                                       id: faktura.documentID,
                                       kwota: faktura["kwota"] as? String ?? "",
                                       notatka: faktura["notatka"] as? String ?? "",
                                       nrFaktury: faktura["nrFaktury"] as? String ?? "",
                                       photoPath: faktura["photoPath"] as? String ?? "",
                                       signature: faktura["signature"] as? String ?? "",
                                       terminPlatnosci: faktura["terminPlatnosci"] as? String ?? "",
                                       zaplacona: faktura["zaplacona"] as? Bool ?? false
                                      ))
                    }
                }
            }
            else{
                print("ERROR, in fetchData in Faktury")
            }
        }
        
    }
}


import Foundation
import Firebase

class HourData: ObservableObject, Identifiable{
    
    @Published var workerName: String
    @Published var startHour: String
    @Published var endHour: String
    @Published var hoursWorked: String
    @Published var day: String
    @Published var month: String
    @Published var year: String
    @Published var signature: String
    @Published var id: String
    
    init(workerName: String, startHour: String, endHour: String, hoursWorked: String, day: String, month: String, year: String, signature: String, id: String){
        
        self.workerName = workerName
        self.startHour = startHour
        self.endHour = endHour
        self.hoursWorked = hoursWorked
        self.day = day
        self.month = month
        self.year = year
        self.signature = signature
        self.id = id
    }
}

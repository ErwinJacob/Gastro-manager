
import Foundation


class Raport: ObservableObject, Identifiable{
    
    @Published var id: String
    
    @Published var time: String
    @Published var signature: String
    
    @Published var utarg: String
    @Published var G: String
    @Published var G0: String
    @Published var T: String
    
    
    
    init(id: String, time: String, signature: String, utarg: String, G: String, G0: String, T: String) {
        self.id = id
        self.time = time
        self.signature = signature

        self.utarg = utarg
        self.G = G
        self.G0 = G0
        self.T = T
    }
}

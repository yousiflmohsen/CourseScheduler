//
//
//import Foundation
//import FirebaseCore
//import FirebaseFirestore
//
//class ViewModel: ObservableObject {
//    @Published var sunetid = ""
//    
//    func getData() {
//        // get a reference to the database
//        let db = Firestore.firestore()
//        
//        // read the documents at a specific path
//        db.collection("user").getDocuments { snapshot, error in
//            if let error = error {
//                // Handle the error
//                print("Error getting documents: \(error)")
//            } else {
//                // No errors
//                for document in snapshot!.documents {
//                    // Update the @Published property, triggering any observers to update
//                    DispatchQueue.main.async {
//                        self.first_name = document.data()["name"] as? String ?? ""
//                        print("Fetched sunetid: \(self.sunetid)") // Debug print
//                    }
//                }
//            }
//        }
//    }
//}

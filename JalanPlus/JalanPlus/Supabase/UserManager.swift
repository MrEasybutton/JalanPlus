import Foundation

class UserManager {
    static let shared = UserManager()
    
    var userID: String?
    
    private init() {}
    
    func checkAuthStatus() async {
        if let user = await SupabaseManager.shared.getCurrentUser() {
            userID = user.id.uuidString
        }
    }
    
    func signInAnonymously(completion: @escaping (Bool) -> Void) {
        SupabaseManager.shared.signInAnonymously { error in
            if error == nil {
                Task {
                    if let user = await SupabaseManager.shared.getCurrentUser() {
                        self.userID = user.id.uuidString
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                print("Anonymous sign-in error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
}

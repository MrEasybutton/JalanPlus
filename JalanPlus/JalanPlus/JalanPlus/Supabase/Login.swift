import Supabase
import SwiftUI
import Foundation

func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
    Task {
        do {
            let _ = try await SupabaseManager.shared.supabase.auth.signUp(email: email, password: password)
            DispatchQueue.main.async { completion(nil) }
        } catch {
            DispatchQueue.main.async { completion(error) }
        }
    }
}

func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
    Task {
        do {
            let _ = try await SupabaseManager.shared.supabase.auth.signIn(email: email, password: password)
            DispatchQueue.main.async { completion(nil) }
        } catch {
            DispatchQueue.main.async { completion(error) }
        }
    }
}

func signOut() {
    Task {
        do {
            try await SupabaseManager.shared.supabase.auth.signOut()
            DispatchQueue.main.async {
            }
        } catch {
            print("Logout error: \(error)")
        }
    }
}


struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                signUp(email: email, password: password) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .padding()

            Button("Log In") {
                signIn(email: email, password: password) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

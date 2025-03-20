import Supabase
import Foundation

struct UserPoints: Codable, Identifiable {
    let id: String
    let points: Int
    let latitude: Double
    let longitude: Double
}

struct Post: Codable, Identifiable {
    let id: String
    let user_id: String
    let content: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id, user_id, content, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        user_id = try container.decode(String.self, forKey: .user_id)
        content = try container.decode(String.self, forKey: .content)
        
        // Handle timestamp parsing
        if let timestampString = try? container.decode(String.self, forKey: .timestamp) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            timestamp = formatter.date(from: timestampString) ?? Date()
        } else {
            timestamp = Date()
        }
    }
    
    init(id: String, user_id: String, content: String, timestamp: Date) {
        self.id = id
        self.user_id = user_id
        self.content = content
        self.timestamp = timestamp
    }
}

class SupabaseManager {
    static let shared = SupabaseManager()

    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://txbjeauffokwwdtmjain.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR4YmplYXVmZm9rd3dkdG1qYWluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0MzM5OTEsImV4cCI6MjA1ODAwOTk5MX0.cVLzIYOKpXu20k3htiaSP36524L_E8I8YitUs9Tep5M"
    )

    func signInAnonymously(completion: @escaping (Error?) -> Void) {
        Task {
            do {
                let session = try await supabase.auth.signInAnonymously()
                let userId = session.user.id
                await createUserIfNeeded(userId: userId)
                DispatchQueue.main.async { completion(nil) }
            } catch {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }

    private func createUserIfNeeded(userId: UUID) async {
        do {
            let response = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .execute()
            
            let data = response.data
            let decoder = JSONDecoder()
            let existingUsers = try? decoder.decode([UserPoints].self, from: data ?? Data())
            
            if existingUsers == nil || existingUsers?.isEmpty == true {
                struct UserInsert: Codable {
                    let id: String
                    let points: Int
                }
                
                let newUser = UserInsert(id: userId.uuidString, points: 0)
                
                try await supabase
                    .from("users")
                    .insert(newUser)
                    .execute()
                
                print("Created new user with ID: \(userId.uuidString)")
            } else {
                print("User already exists with ID: \(userId.uuidString)")
            }
        } catch {
            print("Error creating user: \(error)")
        }
    }

    func getCurrentUser() async -> User? {
        return try? await supabase.auth.session.user
    }
    
    func getUserPoints(userId: UUID) async -> Int {
        do {
            let response = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .execute()
            
            let data = response.data
            let decoder = JSONDecoder()
            let users = try? decoder.decode([UserPoints].self, from: data ?? Data())
            
            return users?.first?.points ?? 0
        } catch {
            print("Error fetching user points: \(error)")
            return 0
        }
    }
    
    func updateUserPoints(userId: UUID, points: Int) async -> Bool {
        do {
            struct UserUpdate: Codable {
                let points: Int
            }
            
            let update = UserUpdate(points: points)
            
            try await supabase
                .from("users")
                .update(update)
                .eq("id", value: userId.uuidString)
                .execute()
            
            return true
        } catch {
            print("Error updating user points: \(error)")
            return false
        }
    }
    
    func updateUserLocation(userId: UUID, latitude: Double, longitude: Double) async -> Bool {
        do {
            struct UserLocationUpdate: Codable {
                let latitude: Double
                let longitude: Double
            }
            
            let locationUpdate = UserLocationUpdate(latitude: latitude, longitude: longitude)
            
            try await supabase
                .from("users")
                .update(locationUpdate)
                .eq("id", value: userId.uuidString)
                .execute()
            
            return true
        } catch {
            print("Error updating user location: \(error)")
            return false
        }
    }
    
    func getAllUsers() async -> [UserPoints]? {
        do {
            let response = try await supabase
                .from("users")
                .select()
                .execute()
            
            let data = response.data
            let decoder = JSONDecoder()
            let users = try? decoder.decode([UserPoints].self, from: data ?? Data())
            
            return users
        } catch {
            print("Error fetching users: \(error)")
            return nil
        }
    }
    
    func getUserPosts(userId: String) async -> [Post]? {
        do {
            print("Fetching posts for user: \(userId)")
            let response = try await supabase
                .from("posts")
                .select()
                .eq("user_id", value: userId)
                .execute()
            
            let data = response.data
            print("Posts response data: \(String(describing: data))")
            
            let decoder = JSONDecoder()
            let posts = try? decoder.decode([Post].self, from: data ?? Data())
            print("Decoded posts: \(String(describing: posts))")
            return posts
        } catch {
            print("Error fetching user posts: \(error.localizedDescription)")
            return nil
        }
    }

    func addPost(userId: String, content: String) async -> String? {
        do {
            let currentUser = try await supabase.auth.session.user
            let authId = currentUser.id.uuidString.lowercased()
            let providedId = userId.lowercased()
            
            print("Auth user ID (lowercase): \(authId)")
            print("User ID being used (lowercase): \(providedId)")
            
            if authId != providedId {
                print("ID MISMATCH: The auth ID doesn't match the ID you're trying to post with")
            }
            
            struct PostInsert: Codable {
                let user_id: String
                let content: String
            }
            
            struct PostResponse: Codable, Identifiable {
                let id: String
                let user_id: String
                let content: String
            }
            
            let newPost = PostInsert(
                user_id: authId,
                content: content
            )

            let response = try await supabase
                .from("posts")
                .insert(newPost)
                .select()
                .execute()
            
            let data = response.data
            let decoder = JSONDecoder()
            if let posts = try? decoder.decode([PostResponse].self, from: data ?? Data()),
               let post = posts.first {
                print("Post added successfully with ID: \(post.id)")
                return post.id
            }
            
            print("Failed to decode post response")
            return nil
        } catch {
            print("Error adding post: \(error.localizedDescription)")
            return nil
        }
    }

    func canPostToday(userId: String) async -> Bool {
        let posts = await getUserPosts(userId: userId)
        let today = Calendar.current.startOfDay(for: Date())
        let todaysPosts = posts?.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
        
        return (todaysPosts?.count ?? 0) < 2
    }

}

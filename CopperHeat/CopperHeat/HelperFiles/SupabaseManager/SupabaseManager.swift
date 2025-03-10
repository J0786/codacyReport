//
//  SupabaseManager.swift
//  CopperHeat
//
//  Created by vtadmin on 04/12/24.
//

import Foundation
import Supabase

// MARK: General Data
struct GeneralData: Decodable {
    let id: Int?
    let facebookLink: String?
    let instaLink: String?
    let youtubeLink: String?
    let linkedinLink: String?
    let currentVersion: String?
    let updatedVersion: String?
    let forceUpdate: Bool?
}

let SUPABASE = SupabaseManager.shared
class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    let adminClient: SupabaseClient
    private init() {
        let supabaseUrl = URL(string: "https://uvozcksmenipoloidntr.supabase.co")! // Replace with your Supabase URL
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2b3pja3NtZW5pcG9sb2lkbnRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI3OTIzMzYsImV4cCI6MjA0ODM2ODMzNn0.w5Bpw4rCJIiX7-A6ZccByvU85RuhV3ibLMQoIMOgoUk" // Replace with your Supabase public API key
        let serviceRole = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2b3pja3NtZW5pcG9sb2lkbnRyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjc5MjMzNiwiZXhwIjoyMDQ4MzY4MzM2fQ.bxkJbZOVcnSsS6ULz5U7jnpw9KRGqWyTmWalKyrinpc"
        self.client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
        self.adminClient = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: serviceRole)
    }
    // MARK: Register With Email
    func registerWithEmail(email: String, password: String, completion: @escaping (User?, String) -> Void) {
        Task {
            do {
                let authResponse = try await client.auth.signUp(email: email, password: password)
                let user = authResponse.user
                completion(user, "")
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
    }
    // MARK: Verify User
    func verifyUser(email: String, otp: String, completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                try await client.auth.verifyOTP(
                    email: email,
                    token: otp,
                    type: .signup
                )
                completion(true, "")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
    }
    // MARK: Resend OTP
    func resendOTP(email: String, completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                try await client.auth.resend(
                    email: email,
                    type: .signup
                )
                completion(true, "")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
    }
    // MARK: Login With Email
    func loginWithEmail(email: String, password: String, completion: @escaping (User?, String) -> Void) {
        Task {
            do {
                let authResponse = try await client.auth.signIn(email: email, password: password)
                let user = authResponse.user
                completion(user, "")
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
    }
    // MARK: Logout
    func logout(completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                try await client.auth.signOut()
                completion(true, "")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
    }
    // MARK: delete User
    func deleteUser(id: String, completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                try await adminClient.auth.admin.deleteUser(id: id)
                completion(true, "")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
    }
    // MARK: General Data
    func fetchGeneralData(completion: @escaping ([GeneralData]?, String) -> Void) {
        Task {
            do {
                let val = try await client.from("general_data").select().execute().value as [GeneralData]
                completion(val, "")
            } catch {
                completion(nil, "")
            }
        }
    }
}

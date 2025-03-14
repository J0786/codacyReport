//
//  LoginVM.swift
//  CopperHeat
//
//  Created by vtadmin on 06/12/24.
//

import Auth

protocol LoginResponse {
    func loginResponseHandle(res: User?, error: String)
    func signupResponsehandle(res: User?, error: String)
    func resendOTPHandle(res: Bool?, error: String)
}

class LoginVM {
    var delegate: LoginResponse?
    func signUp(email: String) {
        SupabaseManager.shared.registerWithEmail(email: email, password: "123456") { result, err  in
            self.delegate?.signupResponsehandle(res: result, error: err)
        }
    }
    func logIn(email: String ) {
        SupabaseManager.shared.loginWithEmail(email: email, password: "123456") { result, error  in
            self.delegate?.loginResponseHandle(res: result, error: error)
        }
    }
    func resendOTP(email: String) {
        SupabaseManager.shared.resendOTP(email: email) { isOtpSend, error  in
            self.delegate?.resendOTPHandle(res: isOtpSend, error: error)
        }
    }
}

// MARK: Current User Model
struct CurrentUser: Codable {
    var id: String?
    var identityId: String?
    var userId: String?
    var email: String?
    var token: String?
    var isEmailVerify: String?
    func syncronize() {
        do {
            if let jsonData = try JSONSerialization.jsonObject(
                with: JSONEncoder().encode(self),
                options: []
            ) as? [String: Any] {
                userDefaults.set(jsonData, forKey: CONSTANT().currentUser)
                userDefaults.synchronize()
            }
        } catch {
            debugPrint("ERROR.User")
        }
    }
    func logout() {
        debugPrint("Logout:- Done")
        appDelegate!.currentUser = nil
        userDefaults.removeObject(forKey: CONSTANT().currentUser)
        userDefaults.synchronize()
        appDelegate!.setAppRoot()
    }
}

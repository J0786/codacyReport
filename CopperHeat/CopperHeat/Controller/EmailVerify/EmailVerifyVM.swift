//
//  EmailVerifyVM.swift
//  CopperHeat
//
//  Created by vtadmin on 06/12/24.
//

import Auth

protocol EmailVerifyResponse {
    func verifyUserhandle(isVerify: Bool?, error: String)
    func resendOTPHandle(isSent: Bool?, error: String)
}

class EmailVerifyVM {
    var delegate: EmailVerifyResponse?

    func verifyUser(email: String, otp: String) {
        SupabaseManager.shared.verifyUser(email: email, otp: otp) { isOtpVerify, err  in
            self.delegate?.verifyUserhandle(isVerify: isOtpVerify, error: err)
        }
    }
    
    func resendOTP(email: String) {
        SupabaseManager.shared.resendOTP(email: email) { isOtpSend, error  in
            self.delegate?.resendOTPHandle(isSent: isOtpSend, error: error)
        }
    }
}

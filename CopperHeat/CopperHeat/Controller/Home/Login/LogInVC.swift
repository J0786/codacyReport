//
//  LogInVC.swift
//  CopperHeat
//
//  Created by vtadmin on 04/10/24.
//

import UIKit
import CoreData
import Auth

class LogInVC: BaseVC {
    // MARK: Outlets
    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblTitleEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginNext: UIButton!
    var dictObj: DeviceModel?
    // MARK: - Variables
    var objLoginVM = LoginVM()
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
    // MARK: actions
    @IBAction func actionBtnLogin(_ sender: UIButton) {
        if !txtEmail.hasText {
            self.showAlert(message: "Please enter your Email Id")
        } else {
            self.loginCall()
        }
    }
}

extension LogInVC {
    func setUi() {
        txtEmail.placeholder = "Enter Email Id"
        btnLogin.round()
        btnLoginNext.round()
        imgLogo.cornerRadius(cornerRadius: 10)
        self.objLoginVM.delegate = self
    }
}

extension LogInVC: LoginResponse {
    func loginCall() {
        self.startLoader()
        objLoginVM.logIn(email: txtEmail.text ?? "")
    }
    func loginResponseHandle(res: User?, error: String) {
        DispatchQueue.main.sync {
            if res == nil {
                if error == "Invalid login credentials" {
                    signupCall()
                } else if error == "Email not confirmed" {
                    resendOtpCall()
                } else {
                    self.stopLoader()
                    self.showAlert(message: error)
                }
            } else {
                self.stopLoader()
                appDelegate!.currentUser = CurrentUser(
                    id: res?.identities?.first?.id ?? "",
                    identityId: res?.identities?.first?.identityId.uuidString ?? "",
                    userId: res?.identities?.first?.userId.uuidString ?? "", email: txtEmail.text ?? "",
                    token: "123456",
                    isEmailVerify: "1")
                appDelegate!.currentUser?.syncronize()
                appDelegate!.setAppRoot()
            }
        }
    }
    func signupCall() {
        objLoginVM.signUp(email: txtEmail.text ?? "")
    }
    func signupResponsehandle(res: User?, error: String) {
        DispatchQueue.main.sync {
            self.stopLoader()
            if res == nil {
                self.showAlert(message: error)
            } else {
                appDelegate!.currentUser = CurrentUser(
                    id: res?.identities?.first?.id ?? "",
                    identityId: res?.identities?.first?.identityId.uuidString ?? "",
                    userId: res?.identities?.first?.userId.uuidString ?? "",
                    email: txtEmail.text ?? "",
                    token: "123456",
                    isEmailVerify: "0")
                appDelegate!.currentUser?.syncronize()
                if let emailVC: EmailVerifyVC = storyBoard.instantiateViewController(
                    withIdentifier: "EmailVerifyVC") as? EmailVerifyVC {
                    emailVC.strEmail = self.txtEmail.text ?? ""
                    self.navigationController?.pushViewController(emailVC, animated: true)
                } else {
                    print("Failed to instantiate EmailVC")
                }
            }
        }
    }
    func resendOtpCall() {
        objLoginVM.resendOTP(email: txtEmail.text ?? "")
    }
    func resendOTPHandle(res: Bool?, error: String) {
        DispatchQueue.main.sync {
            self.stopLoader()
            if res == nil {
                self.showAlert(message: error)
            } else {
                if let emailVC: EmailVerifyVC = storyBoard.instantiateViewController(
                    withIdentifier: "EmailVerifyVC"
                ) as? EmailVerifyVC {
                    emailVC.strEmail = self.txtEmail.text ?? ""
                    self.navigationController?.pushViewController(emailVC, animated: true)
                } else {
                    print("Failed to instantiate EmailVC")
                }
            }
        }
    }
}

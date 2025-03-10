//
//  EmailVerifyVC.swift
//
//
//
//

import UIKit

class EmailVerifyVC: BaseVC {
    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblEmailOrPhone: UILabel!
    @IBOutlet weak var constraintTxtOtpHeight: NSLayoutConstraint!
    @IBOutlet weak var txtOne: SingleDigitField!
    @IBOutlet weak var txtTwo: SingleDigitField!
    @IBOutlet weak var txtThree: SingleDigitField!
    @IBOutlet weak var txtFour: SingleDigitField!
    @IBOutlet weak var txtFive: SingleDigitField!
    @IBOutlet weak var txtSix: SingleDigitField!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTitleDescriptions: UILabel!
    @IBOutlet weak var btnVerifyOtp: UIButton!
    @IBOutlet weak var constraintVerifyOtpButton: NSLayoutConstraint!
    var otp: String = ""
    var expireDate: Date = Date()
    var expireTimer: Timer?
    var strEmail: String = ""
    var objEmailVerifyVM = EmailVerifyVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUi()
        self.setData()
        self.setTextField()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.expireTimerStop()
    }
    @IBAction func actionBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionBtnEdit(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionBtnResendOtp(_ sender: UIButton) {
        self.resendOTPCall()
    }
    @IBAction func actionBtnVerifyOtp(_ sender: UIButton) {
        var isValid = false
        var strOTP = ""
        [txtOne, txtTwo, txtThree, txtFour, txtFive, txtSix].forEach {
            isValid = true
            // strOTP = strOTP + ($0?.text ?? "") // Old Code
            strOTP += $0?.text ?? ""  // New Code
            if $0?.text == "" {
                isValid = false
                $0?.becomeFirstResponder()
                return
            }
        }
        if isValid {
            self.verifyUserCall(otp: strOTP)
        }
    }
}

extension EmailVerifyVC {
    func setUi() {
        btnVerifyOtp.round()
        constraintTxtOtpHeight.constant = IS_IPAD ? IPAD_TEXTFIELD_HEIGHT : (IPHONE_TEXTFIELD_HEIGHT-15)
        btnEdit.cornerRadius(cornerRadius: 5)
        imgLogo.cornerRadius(cornerRadius: 10)
        lblEmailOrPhone.text = strEmail
        objEmailVerifyVM.delegate = self
    }
    func setTextField() {
        [txtOne, txtTwo, txtThree, txtFour, txtFive, txtSix].forEach {
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            $0?.layer.cornerRadius = 5
            $0?.clipsToBounds = true
            
            if IS_IPAD {
                $0?.font = UIFont.systemFont(ofSize: 30)
            } else {
                $0?.font = UIFont.systemFont(ofSize: 20)
            }
            
            $0?.tintColor = .black
            $0?.backgroundColor = .clear
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.colorRed.cgColor
            $0?.addTarget(self, action: #selector(self.txtEditingDidBeginAction(_:)), for: .editingDidBegin)
            $0?.addTarget(self, action: #selector(self.txtEditingDidEndAction(_:)), for: .editingDidEnd)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.txtOne.isUserInteractionEnabled = true
            self.txtOne.becomeFirstResponder()
        }
    }
    @objc func editingChanged(_ textField: SingleDigitField) {
        if textField.pressedDelete {
            textField.pressedDelete = false
            if textField.hasText {
                textField.text = ""
            } else {
                switch textField {
                case txtTwo, txtThree, txtFour, txtFive, txtSix:
                    switch textField {
                    case txtTwo:
                        txtOne.isUserInteractionEnabled = true
                        txtOne.becomeFirstResponder()
                        txtOne.text = ""
                    case txtThree:
                        txtTwo.isUserInteractionEnabled = true
                        txtTwo.becomeFirstResponder()
                        txtTwo.text = ""
                    case txtFour:
                        txtThree.isUserInteractionEnabled = true
                        txtThree.becomeFirstResponder()
                        txtThree.text = ""
                    case txtFive:
                        txtFour.isUserInteractionEnabled = true
                        txtFour.becomeFirstResponder()
                        txtFour.text = ""
                    case txtSix:
                        txtFive.isUserInteractionEnabled = true
                        txtFive.becomeFirstResponder()
                        txtFive.text = ""
                        
                    default:
                        break
                    }
                    textField.resignFirstResponder()
                    textField.isUserInteractionEnabled = false
                default: break
                }
            }
        }
        
        guard textField.text?.count == 1, textField.text?.last?.isWholeNumber == true else {
            textField.text = ""
            return
        }
        switch textField {
        case txtOne, txtTwo, txtThree, txtFour, txtFive:
            switch textField {
            case txtOne:
                txtTwo.isUserInteractionEnabled = true
                txtTwo.becomeFirstResponder()
            case txtTwo:
                txtThree.isUserInteractionEnabled = true
                txtThree.becomeFirstResponder()
            case txtThree:
                txtFour.isUserInteractionEnabled = true
                txtFour.becomeFirstResponder()
            case txtFour:
                txtFive.isUserInteractionEnabled = true
                txtFive.becomeFirstResponder()
            case txtFive:
                txtSix.isUserInteractionEnabled = true
                txtSix.becomeFirstResponder()
            default: break
            }
            textField.resignFirstResponder()
            textField.isUserInteractionEnabled = false
        case txtSix:
            txtSix.resignFirstResponder()
        default: break
        }
    }
    @objc private func txtEditingDidBeginAction(_ sender: SingleDigitField) {
        updateTextFieldState(isEditing: true, sender: sender)
    }
    @objc private func txtEditingDidEndAction(_ sender: SingleDigitField) {
        updateTextFieldState(isEditing: false, sender: sender)
    }
    private func updateTextFieldState(isEditing: Bool, sender: SingleDigitField) {
        if isEditing {
            sender.backgroundColor = .colorRed.withAlphaComponent(0.1)
            sender.textColor = .black
        } else {
            sender.backgroundColor = .clear
        }
    }
    func setData() {
        txtOne.text = ""
        txtTwo.text = ""
        txtThree.text = ""
        txtFour.text = ""
        txtFive.text = ""
        txtSix.text = ""
        
        let coolerFutureDate = Date() + (2 * 60)
        expireDate = coolerFutureDate
        timerStart()
    }
    func convertToLocalFormat(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.date(from: str)
    }
    func timerStart() {
        let strTemp = "You can request a new verification code in "
        lblTime.text = strTemp + self.getExpireTime(startDate: Date(), endDate: expireDate)
        self.lblTime.isHidden = false
        self.btnResend.isHidden = true
        expireTimer?.invalidate()
        expireTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(expireTimerRepeat),
            userInfo: nil,
            repeats: true
        )
    }
    func expireTimerStop() {
        expireTimer?.invalidate()
    }
    @objc func expireTimerRepeat() {
        if Date().compare(expireDate) == .orderedAscending {
            let strTemp = "You can request a new verification code in "
            lblTime.text = strTemp + self.getExpireTime(startDate: Date(), endDate: expireDate)
        } else {
            self.expireTimerStop()
            self.btnResend.isHidden = false
            self.lblTime.isHidden = true
        }
    }
    func getExpireTime(startDate: Date, endDate: Date) -> String {

        let strtDate: Date = Calendar.current.date(bySetting: .nanosecond, value: 0, of: startDate) ?? Date()
        
        let edDate: Date = Calendar.current.date(bySetting: .nanosecond, value: 0, of: endDate) ?? Date()
        var compos: Set<Calendar.Component> = Set<Calendar.Component>()
        compos.insert(.second)
        let cal = Calendar.current.dateComponents(compos, from: strtDate, to: edDate)
        let diffSeconds = cal.second ?? 0
        var strPace = "00:00"
        if diffSeconds > 0 {
            let seconds = diffSeconds % 60
            let minutes = (diffSeconds / 60) % 60
            let hours = diffSeconds / 3600
            
            if hours > 0 {
                strPace = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else if minutes > 0 {
                strPace = String(format: "%02d:%02d", minutes, seconds)
            } else if seconds > 0 {
                strPace = String(format: "00:%02d", seconds)
            } else {
                strPace = "00:00"
            }
        }
        debugPrint("UTC: \(strPace)")
        return strPace
    }
}

extension EmailVerifyVC: EmailVerifyResponse {
    func verifyUserCall(otp: String) {
        self.StartLoader()
        self.objEmailVerifyVM.verifyUser(email: strEmail, otp: otp)
    }
    func verifyUserhandle(isVerify: Bool?, error: String) {
        DispatchQueue.main.async {
            self.StopLoader()
            if isVerify ?? false {
                APP_DEL!.currentUser?.isEmailVerify = "1"
                APP_DEL!.currentUser?.syncronize()
                APP_DEL!.setAppRoot()
            } else {
                self.showAlert(message: "Please Enter Valid OTP Or OTP is Expired.")
            }
        }
    }
    func resendOTPCall() {
        self.StartLoader()
        self.objEmailVerifyVM.resendOTP(email: strEmail)
    }
    func resendOTPHandle(isSent: Bool?, error: String) {
        DispatchQueue.main.async {
            self.StopLoader()
            if isSent ?? false {
                self.setData()
            } else {
                self.showAlert(message: error)
            }
        }
    }
}

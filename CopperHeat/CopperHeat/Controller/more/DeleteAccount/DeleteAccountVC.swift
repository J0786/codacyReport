//
//  DeleteAccountVC.swift
//  CopperHeat
//
//  Created by vtadmin on 11/11/24.
//

import UIKit

class DeleteAccountVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitleDel: UILabel!
    @IBOutlet weak var lblDeleteDescription: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    var objDeleteAccountVM = DeleteAccountVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    @IBAction func actionBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionBtnDelete(_ sender: UIButton) {
        showAlert(message: "Are you sure you want to delete your account?") {
            self.accountDelete()
        } noCompletion: { }
    }
    @IBAction func actionBtnCencel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DeleteAccountVC {
    func setUI() {
        objDeleteAccountVM.delegate = self
        btnDelete.round()
        imgLogo.cornerRadius(cornerRadius: 10)
        btnCancel.round()
        btnCancel.border(borderWidth: 1.0, borderColor: .colorRed)
    }
}

extension DeleteAccountVC: DeleteAccountResponse {
    func accountDelete() {
        startLoader()
        objDeleteAccountVM.deleteAccount(id: appDelegate!.currentUser?.userId ?? "")
    }
    func accountDeleteHandle(isDeleted: Bool?, error: String) {
        DispatchQueue.main.sync {
            self.stopLoader()
            if isDeleted ?? false {
                appDelegate!.currentUser?.logout()
            } else {
                self.showAlert(message: error)
            }
        }
    }
}

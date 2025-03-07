//
//  AddDeviceVC.swift
//  CopperHeat
//
//  Created by vtadmin on 08/11/24.
//

import UIKit
import CoreData

protocol AddNewDel {
    func AddNew(host: String , password: String , deviceName: String)
}

class AddDeviceVC: BaseVC {
    
    
    //MARK: Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitleDescription: UILabel!
    
    @IBOutlet weak var lblTitleHost: UILabel!
    @IBOutlet weak var txtHost: UITextField!
    
    @IBOutlet weak var lblTitlePassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblTitleDeviceName: UILabel!
    @IBOutlet weak var txtDeviceName: UITextField!
    
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnNextConnect: UIButton!
    @IBOutlet weak var btnShow: UIButton!
    
    var delegate : AddNewDel?
    var dictObj : DeviceModel?
 
    //MARK: LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
    
    
    //MARK: actions

    @IBAction func actionBtnConnect(_ sender: UIButton) {
        if !txtHost.hasText {
            self.showAlert(message: "Please enter Controller IP address")
        }else if !txtPassword.hasText{
            self.showAlert(message: "Please enter Password")
        }else{
            arrAddData()
        }
    }
    
    @IBAction func actionBtnHideShow(_ sender: UIButton) {
        
        if txtPassword.isSecureTextEntry {
            txtPassword.isSecureTextEntry = false
            btnShow.setTitle("Hide", for: .normal)
        }else{
            txtPassword.isSecureTextEntry = true
            btnShow.setTitle("Show", for: .normal)
        }
        
    }
    
    
    @IBAction func actionBtnBack(_ sender: UIButton) {
        self.dismiss(animated: false)
    }

}

extension AddDeviceVC {
    
    func setUi(){
        
        txtHost.text = dictObj?.host ?? ""
        txtPassword.text = dictObj?.device_name ?? "111111"
        txtDeviceName.text = dictObj?.device_name ?? ""
        
        txtHost.placeholder = "Enter Controller IP address"
        txtDeviceName.placeholder = "Enter Device Name"
        
        btnConnect.round()
        btnNextConnect.round()
        imgLogo.cornerRadius(cornerRadius: 10)
    }
    
    func arrAddData(){
        
        let entity = NSEntityDescription.entity(forEntityName: "ConnectionItem", in: context)
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue("\(AppDelegate.user.count + 1)", forKey: "id")
        newUser.setValue(5900, forKey: "port")
        newUser.setValue("\(txtPassword.text ?? "111111")", forKey: "password")
        newUser.setValue("\(txtHost.text ?? "")", forKey: "host")
        newUser.setValue("\(txtDeviceName.text ?? "")", forKey: "device_name")

        do {
            try context.save()
            AppDelegate.user.append(newUser)
            self.delegate?.AddNew(host: self.txtHost.text ?? "", password: self.txtPassword.text ?? "", deviceName: self.txtDeviceName.text ?? "")
            self.dismiss(animated: true, completion: nil)
        } catch {
            debugPrint("Failed saving")
        }
        
    }
    
}

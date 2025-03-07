//
//  MenuVC.swift
//  CopperHeat
//
//  Created by vtadmin on 08/10/24.
//

import UIKit
import SafariServices
import AuthenticationServices


struct menuModel : Codable {
    var title : String?
    var img : String?
    var url : String?
}

class MenuVC: BaseVC,ASAuthorizationControllerPresentationContextProviding,SFSafariViewControllerDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblFollowUs: UILabel!
    
    @IBOutlet weak var btnLinkDn: UIButton!
    @IBOutlet weak var btnFaceboook: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnYoutube: UIButton!
    
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    var arrMenu : [menuModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
    }
    
    
    @IBAction func actionBntYoutube(_ sender: UIButton) {
        if let url = URL(string: "https://www.youtube.com/@CooperheatEquipment"){
            redirectToSafariView(url: url)
        }
    }
    
    @IBAction func actionBtnInsta(_ sender: UIButton) {
        if let url = URL(string: "https://www.instagram.com/cooperheatequipment/"){
            redirectToSafariView(url: url)
        }
    }
    
    @IBAction func actionBtnFb(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/cooperheatequipment/"){
            redirectToSafariView(url: url)
        }
    }
    
    @IBAction func actionBtnLinkdin(_ sender: UIButton) {
        if let url = URL(string: "https://www.linkedin.com/company/cooperheat-equipment-ltd/"){
            redirectToSafariView(url: url)
        }
    }
    
    func redirectToSafariView( url : URL ){
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}

extension MenuVC {
    
    func setupview(){
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "MenuCell")

        arrMenu.removeAll()
        arrMenu.append(menuModel(title: "About Us",img: "myaccount_aboutus",url: "https://cooperheatequipment.com/about-us/"))
        arrMenu.append(menuModel(title: "Terms and Conditions",img: "terms_conditions",url: "https://cooperheatequipment.com/terms-conditions/"))
        arrMenu.append(menuModel(title: "Privacy Policy",img: "myaccount_privacy",url: "https://cooperheatequipment.com/privacy-policy-2/"))
        arrMenu.append(menuModel(title: "Contact Us",img: "myaccount_contact_us",url: "https://cooperheatequipment.com/contact-us/"))
        arrMenu.append(menuModel(title: "Delete Account",img: "delete",url: ""))
        arrMenu.append(menuModel(title: "Logout",img: "logout",url: ""))

        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
    
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        if arrMenu[indexPath.row].title == "Logout" {
            cell.lblTitle.text = arrMenu[indexPath.row].title
            cell.imgIcon.image = UIImage(named: arrMenu[indexPath.row].img ?? "")
            cell.imgArrow.isHidden = true
        } else {
            cell.lblTitle.text = arrMenu[indexPath.row].title
            cell.imgIcon.image = UIImage(named: arrMenu[indexPath.row].img ?? "")
            cell.imgArrow.isHidden = false
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrMenu[indexPath.row].title == "Logout" {
            showAlert(message: "Are you sure you want to Logout?") {
                SupabaseManager.shared.logout { isLogout , error  in
                    DispatchQueue.main.sync {
                        if isLogout {
                            APP_DEL.currentUser?.logout()
                        }else{
                            self.showAlert(message: error)
                        }
                    }
                }
            } no: {
                
            }
        }else if arrMenu[indexPath.row].title == "Delete Account" {
            let vc : DeleteAccountVC = STB.instantiateViewController(withIdentifier: "DeleteAccountVC") as! DeleteAccountVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc : CmsVC = STB.instantiateViewController(withIdentifier: "CmsVC") as! CmsVC
            vc.strUrl = arrMenu[indexPath.row].url
            vc.strTitle = arrMenu[indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}

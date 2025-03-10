//
//  MenuVC.swift
//  CopperHeat
//
//  Created by vtadmin on 08/10/24.
//

import UIKit
import SafariServices
import AuthenticationServices

struct MenuModel: Codable {
    var title: String?
    var img: String?
    var url: String?
}

class MenuVC: BaseVC, ASAuthorizationControllerPresentationContextProviding, SFSafariViewControllerDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblFollowUs: UILabel!
    @IBOutlet weak var btnLinkDn: UIButton!
    @IBOutlet weak var btnFaceboook: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnYoutube: UIButton!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    var arrMenu: [MenuModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
    }
    @IBAction func actionBntYoutube(_ sender: UIButton) {
        if let url = URL(string: "https://www.youtube.com/@CooperheatEquipment") {
            redirectToSafariView(url: url)
        }
    }
    @IBAction func actionBtnInsta(_ sender: UIButton) {
        if let url = URL(string: "https://www.instagram.com/cooperheatequipment/") {
            redirectToSafariView(url: url)
        }
    }
    @IBAction func actionBtnFb(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/cooperheatequipment/") {
            redirectToSafariView(url: url)
        }
    }
    @IBAction func actionBtnLinkdin(_ sender: UIButton) {
        if let url = URL(string: "https://www.linkedin.com/company/cooperheat-equipment-ltd/") {
            redirectToSafariView(url: url)
        }
    }
    func redirectToSafariView( url: URL ) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariViewVc = SFSafariViewController(url: url, configuration: config)
        safariViewVc.delegate = self
        self.present(safariViewVc, animated: true)
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true)
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension MenuVC {
    func setupview() {
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "MenuCell")
        arrMenu.removeAll()
        arrMenu.append(MenuModel(
            title: "About Us",
            img: "myaccount_aboutus",
            url: "https://cooperheatequipment.com/about-us/")
        )
        arrMenu.append(MenuModel(
            title: "Terms and Conditions",
            img: "terms_conditions",
            url: "https://cooperheatequipment.com/terms-conditions/")
        )
        arrMenu.append(MenuModel(
            title: "Privacy Policy",
            img: "myaccount_privacy",
            url: "https://cooperheatequipment.com/privacy-policy-2/")
        )
        arrMenu.append(MenuModel(
            title: "Contact Us",
            img: "myaccount_contact_us",
            url: "https://cooperheatequipment.com/contact-us/")
        )
        arrMenu.append(MenuModel(title: "Delete Account", img: "delete", url: ""))
        arrMenu.append(MenuModel(title: "Logout", img: "logout", url: ""))
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell {
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
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrMenu[indexPath.row].title == "Logout" {
            showAlert(message: "Are you sure you want to Logout?") {
                SupabaseManager.shared.logout { isLogout, error  in
                    DispatchQueue.main.sync {
                        if isLogout {
                            APP_DEL!.currentUser?.logout()
                        } else {
                            self.showAlert(message: error)
                        }
                    }
                }
            } no: {
                
            }
        } else if arrMenu[indexPath.row].title == "Delete Account" {
            if let deleteVC = STB.instantiateViewController(withIdentifier: "DeleteAccountVC") as? DeleteAccountVC {
                self.navigationController?.pushViewController(deleteVC, animated: true)
            } else {
                print("Failed to instantiate deleteVC")
            }
        } else {
            if let cmsVC = STB.instantiateViewController(withIdentifier: "CmsVC") as? CmsVC {
                cmsVC.strUrl = arrMenu[indexPath.row].url
                cmsVC.strTitle = arrMenu[indexPath.row].title
                self.navigationController?.pushViewController(cmsVC, animated: true)
            } else {
                print("Failed to instantiate deleteVC")
            }
        }
    }
}

//
//  OfflineVC.swift

import UIKit

class OfflineVC: BaseVC {
     @IBOutlet weak var btnRefresh: UIButton!
     @IBOutlet weak var indicator: UIActivityIndicatorView!
     @IBOutlet weak var lblNoInternetCon: UILabel!
     @IBOutlet weak var lblPleaseCheckInternetConnection: UILabel!
     @IBOutlet weak var constraintHeightBtn: NSLayoutConstraint!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          //        setBtnWithoutView(btn: btnRefresh, cnstrntHeight: constraintHeightBtn)
//          btnRefresh.appThemeFill()
          
          lblNoInternetCon.text = "No Internet connection"
          lblPleaseCheckInternetConnection.text = "Please check your internet connection"
          btnRefresh.setTitle("Retry".uppercased(), for: .normal)
          
//          lblNoInternetCon.font(font: .SemiBold, size: .size_16)
//          lblPleaseCheckInternetConnection.font(font: .SemiBold, size: .size_16)
          
          btnRefresh.titleLabel?.textColor = .black
          
          indicator.isHidden = true
          
          NETWORK.reachability.whenReachable = { _ in

               self.dismissNoNetwork()
          }
     }

     @IBAction func btnRefreshAction(_ sender: UIButton) {
          
          btnRefresh.isHidden = false
          
          indicator.isHidden = false
          indicator.startAnimating()
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               
               self.btnRefresh.isHidden = false
               
               self.indicator.isHidden = true
               self.indicator.stopAnimating()
               
               NetworkManager.isReachable { _ in
                    
                    self.dismissNoNetwork()
               }
          }
     }
     
     func dismissNoNetwork() {
          
          if let topVC: UIViewController = UIApplication.topViewController() {
               
               if topVC.isKind(of: OfflineVC.self) {
                    
                    topVC.dismiss(animated: true, completion: nil)
               }
          }
     }
     
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

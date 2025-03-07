//
//  BaseVC.swift
//  CopperHeat
//
//  Created by vtadmin on 06/11/23.
//

import UIKit
import IQKeyboardManagerSwift
import EmptyDataSet_Swift

class BaseVC: UIViewController {
    
    var isSwipeToBackEnabled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationbar()
    }
    
    func hideNavigationbar(){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Check Application is updated to Latest Version
    //     func CheckUserUpdateVersionOrNot(dictVersion : Versions?) -> Bool {
    //          if dictVersion?.iphoneFlag ?? false {
    //               if (Double(AppInfo().version) ?? 0) < (Double(dictVersion?.iphoneVerionNumber ?? "0.0") ?? 0) {
    //                    self.showAlert(message: "Please update new version from the store.") {
    //                       let iOSAppStoreURL = "https://apps.apple.com/in/app/"
    //                       if let url = URL(string: iOSAppStoreURL) {
    //                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //                       }
    //                   }
    //                   return false
    //               }
    //         }
    //         return true
    //     }
    
}

extension BaseVC : UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {
    func swipePop(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
}


extension BaseVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
    func setNoData(scrollView: UIScrollView!) {
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return .monitor
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "No Devices. \n Click \"Add New\" Button above to add a new device."
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray ,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)
        ]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}

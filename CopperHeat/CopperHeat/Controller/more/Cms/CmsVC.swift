//
//  CmsVC.swift
//  CopperHeat
//
//  Created by vtadmin on 04/10/24.
//

import UIKit
import WebKit

class CmsVC: BaseVC {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var web: WKWebView!
    
    var strUrl: String?
    var strTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StartLoader()
        lbltitle.text = strTitle
        let url = URL(string: strUrl ?? "")
        self.web.navigationDelegate = self
        self.web.load(URLRequest(url: url!))
    }
    
    @IBAction func actionBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CmsVC: WKNavigationDelegate {
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          self.StopLoader()
     }
     
     func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
          self.StopLoader()
     }
}

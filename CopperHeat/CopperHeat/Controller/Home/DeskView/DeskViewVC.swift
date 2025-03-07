//
//  DeskViewVC.swift
//  CopperHeat
//
//  Created by vtadmin on 07/10/24.
//

import UIKit

class DeskViewVC: BaseVC, IRetrieveConnectionId, UIAlertViewDelegate {
    @IBOutlet weak var scrllView: ScrollView!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var ViewCore: ViewerCore?
    var desktopView: DesktopView?
    
    var host: String?
    var port: Int?
    var password: String?
    
    var isConnected: Bool = false
    var isTiledLayout: Bool?
    var connectionId: UInt32?
    
    var condition = NSCondition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.cornerRadius(cornerRadius: 5)
        DesktopView.setTiledLayerOn(false)
        desktopView = DesktopView(viewController: self)
        
        let mousePointerView = MousePointerView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        
        scrllView.addSubview(desktopView!)
        scrllView.setMousePointer(mousePointerView)
        ViewCore = ViewerCore(desktopView: desktopView,
                              mousePointerView: mousePointerView,
                              host: host,
                              port: Int32(port ?? 5900),
                              pixelFormat: PixelFormatWrapper().init32Bit(),
                              jpegQuality: 9,
                              encoding: EncodingDefsWrapper.tight(),
                              retrieveConnectionId: self)
        
    }

    @IBAction func actionBtnStop(_ sender: UIButton) {
        
        self.showAlert(message: "Are you sure you want to disconnect?") {
            self.ViewCore?.stop()
            self.isConnected = false
            self.navigationController?.popViewController(animated: true)
        } no: {
            
        }
        
    }
    
    func askConnectionId() -> UInt32 {
        desktopView?.hideProgressDialog()
        if connectionId == 0 {
            condition = NSCondition()
            DispatchQueue.main.async {
                debugPrint("Async1")
            }
            condition.lock()
            condition.wait()
            condition.unlock()
        }
        return connectionId ?? 0
    }

    func showAskConnectionIdDialog(condition: NSCondition) {

        let alert = UIAlertController(title: "Dispatcher Connection ID", message: "Type dispatcher connection ID below:", preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: "Ok".uppercased(), style: UIAlertAction.Style.default) { _ in }
        let acCancel = UIAlertAction(title: "Cancel".uppercased(), style: UIAlertAction.Style.default) { _ in }
        alert.addAction(acOK)
        alert.addAction(acCancel)
        self.present(alert, animated: true, completion: nil)
        
    }

      func ask() -> UInt32 {

        desktopView?.hideProgressDialog()
        if connectionId == 0 {
            condition = NSCondition()
            condition.lock()
            condition.wait()
            condition.unlock()
        }
        return connectionId ?? 0
    }
    
}

extension DeskViewVC: ViewControllerCallbackDelegate {
    func onEstablished() {
        isConnected = true

    }
    
    func onError(_ errorMessage: String!) {
        if isConnected {
            self.showAlert(message: errorMessage) {
                self.ViewCore?.stop()
                self.isConnected = false
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func onDisconnect(_ message: String!) {
        print(message as Any)
    }
    
    func updateMouseToolPosition(_ position: CGPoint) {
        
    }
    
    func askPassword() -> String! {
        desktopView?.hideProgressDialog()
        if password == nil || password == "" {
            condition = NSCondition()
            DispatchQueue.main.async {

            }
            condition.lock()
            condition.wait()
            condition.unlock()
        }
        return password
    }
}

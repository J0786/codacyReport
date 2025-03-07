//
//  Constant.swift
//
//
//

import UIKit

let APP_DEL = UIApplication.shared.delegate as! AppDelegate
let STB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let UD = UserDefaults.standard
let context = APP_DEL.persistentContainer.viewContext

let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad ? true : false

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let indicatorType = NVActivityIndicatorType.ballPulse
let INDECATOR_SIZE = CGSize(width: 50, height: 50)
let CORNER_VIEW_SIZE = 5.0
let IPHONE_TEXTFIELD_HEIGHT = 60.0
let IPAD_TEXTFIELD_HEIGHT = 80.0

let IPHONE_BTN_HEIGHT = 50.0
let IPAD_BTN_HEIGHT = 70.0

let animationView: UIView = UIView()
let img: UIImageView = UIImageView()

class CONSTANT {
    
    let currentUser = "currentUser"
    let apiDateFormate_ymd_hms = "yyyy-MM-dd HH:mm:ss"
    let apiDateFormate_hms = "HH:mm:ss"
    let appDateFormate_ymd = "yyyy-MM-dd"
    let appDateFormate_ymd_hm_a = "yyyy-MM-dd hh:mm a"
    let appDateFormate_hma = "hh:mm a"
    let appDateFormate_dd_mmm_yyyy = "dd MMM, yyyy"
    
}

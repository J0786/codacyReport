//
//  Constant.swift
//
//
//

import UIKit
import NVActivityIndicatorView

let appDelegate = UIApplication.shared.delegate as? AppDelegate
let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let userDefaults = UserDefaults.standard
let context = appDelegate!.persistentContainer.viewContext
let isIPAD = UIDevice.current.userInterfaceIdiom == .pad ? true : false
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let indicatorType = NVActivityIndicatorType.ballPulse
let indecatorSize = CGSize(width: 50, height: 50)
let cornerViewSize = 5.0
let iPhoneTextFieldHeight = 60.0
let iPadTextFieldHeight = 80.0
let iPhoneBtnHeight = 50.0
let iPadBtnHeight = 70.0
let animationView: UIView = UIView()
let img: UIImageView = UIImageView()
class CONSTANT {
    let currentUser = "currentUser"
    let apiDateFormateyMdHms = "yyyy-MM-dd HH:mm:ss"
    let apiDateFormateHms = "HH:mm:ss"
    let appDateFormateyMd = "yyyy-MM-dd"
    let appDateFormateyMdhma = "yyyy-MM-dd hh:mm a"
    let appDateFormatehma = "hh:mm a"
    let appDateFormateddMMMyyyy = "dd MMM, yyyy"
}

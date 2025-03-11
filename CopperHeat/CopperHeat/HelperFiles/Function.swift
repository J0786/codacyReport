//
//  Function.swift

import UIKit
import AVFoundation
import Foundation
import QuickLook
import Photos
import PhotosUI

class FUNCTION {
    func getDataFromJsonFile(fileName: String) -> Data? {
        do {
            let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
            let jsonData = try Data(contentsOf: url)
            return jsonData
        } catch {
            return nil
        }
    }
//    func getFont(for font: FontName, size: FontSize) -> UIFont {
//         if UIView.appearance().semanticContentAttribute == .forceLeftToRight {
//              return UIFont(name: font.english, size: getFontSize(size: size.rawValue))!
//         }else{
//              return UIFont(name: font.arabic, size: getFontSize(size: size.rawValue))!
//         }
//    }
    func getColorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func isValidPassword(password: String) -> Bool {
        let passwordRegex: String = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,15}$"
        let predicateForPassword: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicateForPassword.evaluate(with: password)
    }
     func getTotal(arrSubTotal: [String]) -> String {
         let doubles = arrSubTotal.compactMap(Double.init)
         let sum = doubles.reduce(0, +)
         return "\(sum)"
     }
    func isValidContactNumEditScreen(number: String, lenght: String, crCode: String) -> Bool {
        let count = (crCode.count)+1+(Int(lenght) ?? 8)
        if number.count > count {
            return false
        } else if number.count < count {
            return false
        } else {
            return true
        }
    }
    func formatedNumber(formate: String, number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for char in formate where index < cleanPhoneNumber.endIndex {
            if char == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
//    func getFontSize(size: CGFloat) -> CGFloat {
//        
//        var sizeNew = size
//        
//        if SCREEN_HEIGHT >= 736 {
//            sizeNew = sizeNew + 2.0
//        } else if SCREEN_HEIGHT >= 667 {
//            sizeNew = sizeNew + 1.5
//        } else if SCREEN_HEIGHT <= 568 {
//            sizeNew = sizeNew + 1.0
//        }
//        
//        if IS_IPAD {
//            sizeNew = sizeNew + 2.5
//        }
//        
//        return sizeNew
//    }
    func getLocalCountryCode() -> String? {
        return (Locale.current as NSLocale).object(forKey: .countryCode) as? String
    }
    func setAttributedStringforStatus(_ str: String) -> NSAttributedString {
        var atrstrStatus = str
        var arr = atrstrStatus.components(separatedBy: " : ")
        if arr.count != 2 {
            atrstrStatus = atrstrStatus.replacingOccurrences(of: ": ", with: "")
            atrstrStatus = atrstrStatus.replacingOccurrences(of: " :", with: "")
            arr = atrstrStatus.components(separatedBy: ":")
        }
        let attString = NSMutableAttributedString(string: String(format: "%@ : ", arr[0]))
        let attString1 = NSMutableAttributedString(string: String(format: "%@", arr[1]))
        attString1.addAttribute(
            .foregroundColor,
            value: UIColor.blue,
            range: NSRange(location: 0, length: attString1.length)
        )
        attString.append(attString1)
        return attString
    }
    func convertDateFormate(date: Date) -> String {
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: date)
        var day  = "\(anchorComponents.day!)"
        switch day {
        case "1", "21", "31":
            day.append("st")
        case "2", "22":
            day.append("nd")
        case "3", "23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    func convertServerDateTime(toLocalDeviceDateTime strDateTime: String,
                               isFromChatDetails: Bool) -> String? {
        guard let date = parseDate(from: strDateTime) else {
            return nil
        }
        let destinationDate = convertToLocalDate(from: date)
        return formatDate(destinationDate, isFromChatDetails: isFromChatDetails)
    }
    private func parseDate(from strDateTime: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: strDateTime)
    }
    private func convertToLocalDate(from date: Date) -> Date {
        let currentTimeZone = TimeZone.current
        let utcTimeZone = TimeZone(abbreviation: "UTC")!
        let currentGMTOffset = currentTimeZone.secondsFromGMT(for: date)
        let gmtOffset = utcTimeZone.secondsFromGMT(for: date)
        let gmtInterval = TimeInterval(currentGMTOffset - gmtOffset)
        return Date(timeInterval: gmtInterval, since: date)
    }
    private func formatDate(_ date: Date, isFromChatDetails: Bool) -> String {
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(date)
        let dayCount = timeDifference / 86400.0
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        if dayCount <= 0.50 {
            dateFormatter.dateFormat = "hh:mm a"
            let timeString = dateFormatter.string(from: date)
            return isFromChatDetails ? "Today \(timeString)" : timeString
        } else if dayCount > 0 && dayCount < 2 {
            dateFormatter.dateFormat = "hh:mm a"
            let timeString = dateFormatter.string(from: date)
            return isFromChatDetails ? "Yesterday \(timeString)" : "Yesterday"
        } else {
            dateFormatter.dateFormat = isFromChatDetails ? "dd MMM yy hh:mm a" : "dd MMM yy"
            return dateFormatter.string(from: date)
        }
    }
    func getImages(assets: [PHAsset], completion: @escaping ([UIImage]) -> Void) {
        let group = DispatchGroup()
        var images: [UIImage] = []
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.version = .current
        options.resizeMode = .exact
        let manager = PHImageManager.default()
        for asset in assets {
            let width: CGFloat = CGFloat(asset.pixelWidth)
            let height: CGFloat = CGFloat(asset.pixelHeight)
            let size = CGSize(width: width * 0.5, height: height * 0.5)
            group.enter()
            manager.requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFill,
                options: options
            ) { (image, _) in
                if let image = image {
                    images.append(image)
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion(images)
        }
    }
//    func textToHtml(str: String) -> String {
//        let htmlString = str.stringByDecodingHTMLEntities
//        return htmlString
//    }
}
struct AppInfo {
    var appName: String {
        return readFromInfoPlist(withKey: "CFBundleName") ?? "(unknown app name)"
    }
    var version: String {
        return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
    }
    var build: String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
    }
    var minimumOSVersion: String {
        return readFromInfoPlist(withKey: "MinimumOSVersion") ?? "(unknown minimum OSVersion)"
    }
    var copyrightNotice: String {
        return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? "(unknown copyright notice)"
    }
    var bundleIdentifier: String {
        return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
    }
    // lets hold a reference to the Info.plist of the app as Dictionary
    private let infoPlistDictionary = Bundle.main.infoDictionary
    /// Retrieves and returns associated values (of Type String) from info.Plist of the app.
    private func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
}

//
//  Extention.swift


import UIKit
import ImageIO
import PDFKit
import QuickLookThumbnailing
import WebKit

extension UIViewController {
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
    
    func backaction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func isModal() -> Bool {
        
        return self.presentingViewController?.presentedViewController == self || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    func showToast(message : String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .white
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.8) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Copper Master", message: message, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: "Ok".uppercased(), style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPopAlert(message: String) {
        
        let alert = UIAlertController(title: "Copper Master", message: message, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: "Ok".uppercased(), style: UIAlertAction.Style.default) { (action) in
            
            if self.isModal() {
                self.dismiss(animated: true, completion: nil)
            } else if let navC : UINavigationController = self.navigationController, navC.viewControllers.count > 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(attributedText: NSAttributedString) {
        
        
        
        let alert = UIAlertController(title: "Copper Master", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.setValue(attributedText, forKey: "attributedTitle")
        
        let acOK = UIAlertAction(title: "Ok".uppercased(), style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(acOK)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func showAlert(message: String, actionTitles: [String], actions: [((UIAlertAction) -> Void)]) {
        
        
        
        let alertController = UIAlertController(title: "Copper Master", message: message, preferredStyle: .alert)
        
        for(index, indexTitle) in actionTitles.enumerated(){
            
            let action = UIAlertAction(title: indexTitle, style: .default, handler: actions[index])
            
            alertController.addAction(action)
            
        }
        
        self.present(alertController, animated: true)
        
    }
    
    func showAlert(message: String, completion: @escaping () -> ()) {
        
        let alert = UIAlertController(title: "Copper Master", message: message, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: "Ok".uppercased(), style: UIAlertAction.Style.default) { (action) in
            
            completion()
        }
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, completion: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acOK = UIAlertAction(title: "Ok".uppercased(), style: UIAlertAction.Style.default) { (action) in
            
            completion()
        }
        alert.addAction(acOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, yes: @escaping () -> (), no: @escaping () -> ()) {
        
        let alert = UIAlertController(title: "Copper Master", message: message, preferredStyle: UIAlertController.Style.alert)
        let acYes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            yes()
        }
        let acNo = UIAlertAction(title:"No", style: UIAlertAction.Style.default) { (action) in
            no()
        }
        alert.addAction(acYes)
        alert.addAction(acNo)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc public func setGradientNavigation() {
        
        guard let navigationController = navigationController,let flareGradientImage = CAGradientLayer.primaryNavigationGradient(on: navigationController.navigationBar)
        else {
            debugPrint("Error creating gradient color!")
            return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
    }
    
}


extension UIViewController : NVActivityIndicatorViewable {

    func StartLoaderwithMsg(message : String){
        startAnimating(INDECATOR_SIZE, message: message, type: indicatorType , color: UIColor.colorRed,  backgroundColor: UIColor.clear, fadeInAnimation: nil)
    }

    func StartLoader(){
         startAnimating(INDECATOR_SIZE, message: "", type: indicatorType , color: UIColor.colorRed,  backgroundColor: UIColor.clear, fadeInAnimation: nil)
    }

    func StopLoader(){
        self.stopAnimating(nil)
    }

}



extension UIApplication {
    
    class func windowAlert(message: String) {
        
        var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level.alert + 1
        
        let alert: UIAlertController =  UIAlertController(title: "Copper Master", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (alertAction) in
            topWindow?.isHidden = true
            topWindow = nil
        }))
        
        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion:nil)
    }
    
}




extension UIView {
    
    func addDashedBorder() {
        let color = UIColor.black.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func setGradient(startColor: UIColor, endColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func round() {
        
        self.layer.cornerRadius = frame.size.height / 2.0
        self.clipsToBounds = true
    }
    
    func cornerRadius(cornerRadius: CGFloat, clipsToBounds: Bool = true) {
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
    }
    
    func cornerRadius(corners: CACornerMask, cornerRadius: CGFloat, clipsToBounds: Bool = true) {
        
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
    }
    
    func border(borderWidth: CGFloat, borderColor: UIColor) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func shadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat) {
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
        
    }
    
    
    func makeCardView() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
    
    
    
    func addBorderToView(color: UIColor, width: CGFloat, radius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    
    
    func screenShot() -> UIImage? {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        else { fatalError("missing expected nib named: \(name)") }
        guard
            /// we're using `first` here because compact map chokes compiler on
            /// optimized release, so you can't use two views in one nib if you wanted to
            /// and are now looking at this
            let view = nib.first as? Self
        else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}





extension UILabel {
    
    //    func font(font: FontName, size: FontSize) {
    //         if UIView.appearance().semanticContentAttribute == .forceLeftToRight {
    //              self.font = UIFont(name: font.english, size: FUNCTION().getFontSize(size: size.rawValue))!
    //         }else{
    //              self.font = UIFont(name: font.arabic, size: FUNCTION().getFontSize(size: size.rawValue))!
    //         }
    //    }
    
}

extension UILabel {
    
    func textWidth() -> CGFloat {
        
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        return textSize(font: font, text: text).width
    }
    
    class func textHeight(withWidth width: CGFloat, font: UIFont, text: String) -> CGFloat {
        
        return textSize(font: font, text: text, width: width).height
    }
    
    class func textSize(font: UIFont, text: String, extra: CGSize) -> CGSize {
        
        var size = textSize(font: font, text: text)
        size.width = size.width + extra.width
        size.height = size.height + extra.height
        return size
    }
    
    class func textSize(font: UIFont, text: String, width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size
    }
    
    class func countLines(font: UIFont, text: String, width: CGFloat, height: CGFloat = .greatestFiniteMagnitude) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = text as NSString
        
        let rect = CGSize(width: width, height: height)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
    
    
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    
    
    func countLines(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> Int {
        
        // Call self.layoutIfNeeded() if your view uses auto layout
        //self.layoutIfNeeded()
        
        let myText = (self.text ?? "") as NSString
        
        let rect = CGSize(width: width, height: height)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        
        let targetRange = (lblText as NSString).range(of: targetText)
        
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes([NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize], range: NSRange(location: 0, length: attributedString.length))
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UITableView {
    
    func reloadWithoutScroll() {
        
        let offset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }
}




extension UIColor {
    
    public convenience init(hex: String) {
        
        let r, g, b, a: CGFloat
        
        var hex = hex
        
        if hex.hasPrefix("#") == false {
            hex = "#" + hex
        }
        
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        } else if hexColor.count == 6 {
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                b = CGFloat(hexNumber & 0x0000FF) / 255.0
                
                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
        return
    }
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            
            self.setFill()
            
            rendererContext.fill(CGRect(origin: .zero, size: size))
            
        }
        
    }
    
}

extension UIImageView {
    
    //    func setImageWith(urlString: String, displayIndicater: Bool = false, placeholder: String = IMAGE().placeholder) {
    //
    //        if displayIndicater {
    //            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
    //        }
    //
    //        self.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: placeholder), options: SDWebImageOptions.refreshCached, context: nil)
    //    }
    
    //    func setImageDocWith(urlString: String? = nil, urlURL: URL? = nil, displayIndicater: Bool = false, placeholder: String = IMAGE().placeholder) {
    //
    //        if displayIndicater {
    //            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
    //        }
    //
    //        var tempURL : URL?
    //        if let str = urlString {
    //            tempURL = URL(string: str)
    //        } else if let url = urlURL {
    //            tempURL = url
    //        }
    //
    //        if let finalURL = tempURL {
    //
    //            let pathExtension = finalURL.pathExtension
    //
    //            if pathExtension == "doc" {
    //
    //                self.image = UIImage(named: "doc")
    //
    //            } else if pathExtension == "pdf" {
    //
    //                let width: CGFloat = 240
    //
    //                guard let data = try? Data(contentsOf: finalURL), let page = PDFDocument(data: data)?.page(at: 0) else {
    //                    return
    //                }
    //
    //                let pageSize = page.bounds(for: .mediaBox)
    //                let pdfScale = width / pageSize.width
    //
    //                // Apply if you're displaying the thumbnail on screen
    //                let scale = UIScreen.main.scale * pdfScale
    //                let screenSize = CGSize(width: pageSize.width * scale, height: pageSize.height * scale)
    //
    //                self.image = page.thumbnail(of: screenSize, for: .mediaBox)
    //            }
    //        }
    //    }
    
    func setHieghtByAspectToWidth() -> CGFloat {
        
        let ratio = CGFloat(image?.size.width ?? 0.0) / CGFloat(image?.size.height ?? 0.0)
        let newHeight = self.frame.width / ratio
        return newHeight
    }
    
    
    
    //For load gif file
    //    public func loadGif(name: String) {
    //
    //        DispatchQueue.global().async {
    //
    //            let image = UIImage.gif(name: name)
    //
    //            DispatchQueue.main.async {
    //
    //                self.image = image
    //            }
    //        }
    //    }
    
    //    @available(iOS 9.0, *)
    //    public func loadGif(asset: String) {
    //
    //        DispatchQueue.global().async {
    //
    //            let image = UIImage.gif(asset: asset)
    //
    //            DispatchQueue.main.async {
    //
    //                self.image = image
    //            }
    //        }
    //    }
}

extension UIImage {
    
    func compressImage(compressionQuality: CGFloat = 0.5) -> (image: UIImage?, data: Data?) {
        
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        
        let maxHeight : CGFloat = 2524.0
        let maxWidth : CGFloat = 3532.0
        
        var currentRatio : CGFloat = actualWidth / actualHeight
        let maxRatio : CGFloat = maxWidth / maxHeight
        
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if currentRatio < maxRatio {
                //adjust width according to maxHeight
                currentRatio = maxHeight / actualHeight;
                actualWidth = currentRatio * actualWidth;
                actualHeight = maxHeight;
            } else if currentRatio > maxRatio {
                //adjust height according to maxWidth
                currentRatio = maxWidth / actualWidth;
                actualHeight = currentRatio * actualHeight;
                actualWidth = maxWidth;
            } else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let imageRect : CGRect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(imageRect.size)
        self.draw(in: imageRect)
        
        guard let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            
            return (image: self, data: jpegData(compressionQuality: compressionQuality))
        }
        
        guard let tempData : Data = newImage.jpegData(compressionQuality: compressionQuality) else {
            
            UIGraphicsEndImageContext(); return (image: self, data: jpegData(compressionQuality: compressionQuality))
        }
        
        UIGraphicsEndImageContext();
        
        if let finalImage : UIImage = UIImage(data: tempData) {
            return (image: finalImage, data: tempData)
        } else {
            return (image: self, data: jpegData(compressionQuality: compressionQuality))
        }
    }
    
    
    
    //For load gif file
    public class func gif(data: Data) -> UIImage? {
        
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            
            debugPrint("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    //For load gif file
    public class func gifByUrl(url: URL?) -> UIImage? {
        
        guard let imgUrl = url else {
            
            debugPrint("SwiftGif: url doesn't exist")
            return nil
        }
        
        // Create source from data
        guard let source = CGImageSourceCreateWithURL(imgUrl as CFURL, nil) else {
            
            debugPrint("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            
            debugPrint("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            
            debugPrint("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        
        // Check for existance of gif
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            
            debugPrint("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            
            debugPrint("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            
            debugPrint("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension Data {
    
    
    var imageType: String {
        
        let array = [UInt8](self)
        
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "png"
        }
        return ext
    }
}


extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    
    func toJSONString() -> String? {
        if let jsonData = jsonData {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        
        return nil
    }
    
    func decode<T:Codable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: jsonData ?? Data())
    }
    
}

extension URL {
    
    func getInfo() -> (bytes: Double, kb: Double, mb: Double, gb: Double) {
        
        do {
            
            let res = try self.resourceValues(forKeys: [.fileSizeKey])
            
            if let resBytes : Int = res.fileSize {
                
                let resBytesInt64 : Int64 = Int64(resBytes)
                return (bytes: Double(Units(bytes: resBytesInt64).bytes),
                        kb: Double(Units(bytes: resBytesInt64).kilobytes),
                        mb: Double(Units(bytes: resBytesInt64).megabytes),
                        gb: Double(Units(bytes: resBytesInt64).gigabytes));
            }
        } catch { }
        
        return (bytes: 0.0, kb: 0.0, mb: 0.0, gb: 0.0);
    }
}

public struct Units {
    
    public let bytes: Int64
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    
    public var gigabytes: Double {
        return megabytes / 1_024
    }
    
    public init(bytes: Int64) {
        self.bytes = bytes
    }
    
    public func getReadableUnit() -> String {
        
        switch bytes {
        case 0..<1_024:
            return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
            return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
            return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return "\(String(format: "%.2f", gigabytes)) gb"
        default:
            return "\(bytes) bytes"
        }
    }
}



extension String {
    
    func getHtml() -> (string: String?, attributedString: NSAttributedString?) {
        
        guard let data = data(using: .utf8) else { return (string: nil, attributedString: nil) }
        
        do {
            let attStr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            return (string: attStr.string, attributedString: attStr)
        } catch {
            debugPrint("error:", error)
            return (string: nil, attributedString: nil)
        }
    }
    
    func firstLetter() -> String {
        
        guard let firstChar = self.first else {
            return ""
        }
        return String(firstChar)
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        
        let from = range.lowerBound.samePosition(in: utf16)
        
        let to = range.upperBound.samePosition(in: utf16)
        
        if from != nil && to != nil {
            
            return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                           
                           length: utf16.distance(from: from!, to: to!))
            
        }
        
        return nil
        
    }
    
    func between(left: String, right: String) -> String? {
        
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
                ,leftRange.upperBound <= rightRange.lowerBound else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func getKey(extention: Bool = true) -> String {
        
        let new = self.replacingOccurrences(of: " ", with: "")
        
        if var tempUrl = URL(string: new) {
            
            if extention == false {
                tempUrl.deletePathExtension()
            }
            
            return tempUrl.lastPathComponent
            
        } else {
            return "";
        }
    }
    
    func isEN() -> Bool {
        
        return (CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").isSuperset(of: CharacterSet(charactersIn: self)))
    }
    
    func getArToEnDigit() -> String {
        
        struct EnAr {
            let en : String
            let ar : String
        }
        
        let arDigit: [EnAr] = [
            EnAr(en: "0", ar: "٠"),
            EnAr(en: "1", ar: "١"),
            EnAr(en: "2", ar: "٢"),
            EnAr(en: "3", ar: "٣"),
            EnAr(en: "4", ar: "٤"),
            EnAr(en: "5", ar: "٥"),
            EnAr(en: "6", ar: "٦"),
            EnAr(en: "7", ar: "٧"),
            EnAr(en: "8", ar: "٨"),
            EnAr(en: "9", ar: "٩")
        ]
        
        var res = self
        for digit in arDigit {
            res = res.replacingOccurrences(of: digit.ar, with: digit.en)
        }
        
        return res;
    }
    
    
    func validateStringContainAlphabetsOnly() -> Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
                return false
            } else {
                return true
            }
        }
        catch {
            debugPrint("ERROR")
            return false
        }
    }
    
    func changeDateFormate(iFormate: String, oFormate: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = iFormate
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = oFormate
            
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    
    func convertOrderDate() -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM dd, yyyy HH:mm"
            
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    
    
}

extension Double {
    
    /// Rounds the double to decimal places value
    func roundToPlaces(places: Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension NSMutableAttributedString {
    
    func  appendAttributedString(string: String,
                                 color: UIColor? = nil,
                                 backgroundColor: UIColor? = nil,
                                 strikethroughStyle: Int? = nil,
                                 shadowBlurRadius: Int? = nil,
                                 shadowOffset: CGSize? = nil,
                                 shadowColor: UIColor? = nil,
                                 strokeWidth: Int? = nil,
                                 underlineStyle: NSUnderlineStyle? = nil,
                                 font: UIFont? = nil)
    {
        self.append(FUNCTION().getAttributedString(string: string, color: color, backgroundColor: backgroundColor, strikethroughStyle: strikethroughStyle, shadowBlurRadius: shadowBlurRadius, shadowOffset: shadowOffset, shadowColor: shadowColor, strokeWidth: strokeWidth, underlineStyle: underlineStyle, font: font))
    }
}




class ActivityLoader: NSObject {
    
    //MARK:- Start ActivityLoader
    class func startActivityLoader(onView : UIView) -> UIView {
        
        let activityLoaderView = UIView.init(frame: onView.bounds)
        activityLoaderView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityLoader = UIActivityIndicatorView.init(style: .whiteLarge)
        activityLoader.color = UIColor.black
        activityLoader.startAnimating()
        activityLoader.center = activityLoaderView.center
        
        DispatchQueue.main.async {
            activityLoaderView.addSubview(activityLoader)
            onView.addSubview(activityLoaderView)
        }
        
        return activityLoaderView
    }
    
    //MARK:- Stop ActivityLoader
    class func stopActivityLoader(loaderView :UIView) {
        DispatchQueue.main.async {
            loaderView.removeFromSuperview()
        }
    }
}




extension CAGradientLayer {
    
    class func primaryNavigationGradient(on view: UIView) -> UIImage? {
        
        let gradient = CAGradientLayer()
        let flareRed = UIColor(displayP3Red: 92.0/255.0, green: 178.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        let flareOrange = UIColor(displayP3Red: 154.0/255.0, green: 209.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [flareRed.cgColor, flareOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext()
        {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}




extension Character {
    
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    
    func getRatingText() -> String {
        if let doubRating = Double(self) {
            return String(format: "%.1f", doubRating)
        } else {
            return "0.0"
        }
    }
    
    
    
}

extension String {
    
    func getCommaValue()->String{
        
        let formatter = NumberFormatter()
        // Set up the NumberFormatter to use a thousands separator
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        
        //Set it up to always display 2 decimal places.
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let string = formatter.string(from:NSNumber(value:Double(self) ?? 0.00)){
            return string
        }
        
        return ""
    }
    
    
}

extension NumberFormatter {
    convenience init(style: Style) {
        self.init()
        self.numberStyle = style
    }
}
extension Formatter {
    static let currency = NumberFormatter(style: .currency)
}
extension FloatingPoint {
    var currency: String {
        return Formatter.currency.string(for: self) ?? ""
    }
}

extension String {
    
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains { !$0.isEmoji }
    }
    
    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }
    
    var emojis: [Character] {
        return filter { $0.isEmoji }
    }
    
    var emojiScalars: [UnicodeScalar] {
        return filter { $0.isEmoji }.flatMap { $0.unicodeScalars }
    }
    
    
    var encodeEmoji: String {
        
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue) {
            
            return encodeStr as String
        }
        
        return self
    }
    
    var decodeEmoji: String {
        
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        
        if let str = decodedStr {
            
            return str as String
        }
        return self
    }
}

extension URL {
    
    var filesize: Int? {
        let set = Set.init([URLResourceKey.fileSizeKey])
        var filesize: Int?
        do {
            let values = try self.resourceValues(forKeys: set)
            if let theFileSize = values.fileSize {
                filesize = theFileSize
            }
        }
        catch {
            print("Error: \(error)")
        }
        return filesize
    }
    
    var filesizeNicelyformatted: String? {
        guard let fileSize = self.filesize else {
            return nil
        }
        return ByteCountFormatter.init().string(fromByteCount: Int64(fileSize))
    }
    
    var queryParameters: QueryParameters {
        return QueryParameters(url: self)
    }
    
    
    func download(to directory: FileManager.SearchPathDirectory, using fileName: String? = nil, overwrite: Bool = false, completion: @escaping (URL?, Error?) -> Void) throws {
        let directory = try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination: URL
        
        if let fileName = fileName {
            destination = directory
                .appendingPathComponent(fileName)
                .appendingPathExtension(self.pathExtension)
        } else {
            destination = directory
                .appendingPathComponent(lastPathComponent)
        }
        
        if !overwrite, FileManager.default.fileExists(atPath: destination.path) {
            completion(destination, nil)
            return
        }
        
        URLSession.shared.downloadTask(with: self) { location, _, error in
            guard let location = location else {
                completion(nil, error)
                return
            }
            do {
                if overwrite, FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.moveItem(at: location, to: destination)
                completion(destination, nil)
            } catch {
                debugPrint(error)
            }
        }.resume()
        
    }
}

class QueryParameters {
    let queryItems: [URLQueryItem]
    init(url: URL?) {
        queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
        print(queryItems)
    }
    subscript(name: String) -> String? {
        return queryItems.first(where: { $0.name == name })?.value
    }
}

extension StringProtocol {
    func nsRange<S: StringProtocol>(of string: S, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> NSRange? {
        self.range(of: string,
                   options: options,
                   range: range ?? startIndex..<endIndex,
                   locale: locale ?? .current)?
            .nsRange(in: self)
    }
    func nsRanges<S: StringProtocol>(of string: S, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> [NSRange] {
        var start = range?.lowerBound ?? startIndex
        let end = range?.upperBound ?? endIndex
        var ranges: [NSRange] = []
        while start < end,
              let range = self.range(of: string,
                                     options: options,
                                     range: start..<end,
                                     locale: locale ?? .current) {
            ranges.append(range.nsRange(in: self))
            start = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return ranges
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}


extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}

extension UIView {
    
    // Export pdf from Save pdf in drectory and return pdf file path
    func exportAsPdfFromView(strPdfName : String) -> String {
        
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData, strPdfName: strPdfName)
        
    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData,strPdfName : String) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("\(strPdfName).pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

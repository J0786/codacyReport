//
//  AppDelegate.swift
//  CopperHeat
//
//  Created by vtadmin on 04/10/24.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var user : [NSManagedObject] = []
    var currentUser : CurrentUser?
    var dictGenData : GeneralData?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = false
        IQKeyboardManager.shared.enable = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            NETWORK.reachability.whenUnreachable = { reachability in
                if let topVC : UIViewController = UIApplication.topViewController(){
                    let vc = OfflineVC(nibName: "OfflineVC", bundle: nil)
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    topVC.present(vc, animated: true, completion: nil)
                }
            }
        })
        
        let vc : SplashVC = STB.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        APP_DEL.setRootWindow(vc: vc, isNavigation: false)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ConnectionList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: is Logged In User Found
    private func isLoggedInUserFound() -> Bool {
        if  (UD.value(forKey: CONSTANT().currentUser) != nil), let dict  = UD.value(forKey:CONSTANT().currentUser) {
            let dictUser : [String : Any] = dict as! [String : Any]
            if let jsonData = try? JSONSerialization.data(withJSONObject: dictUser, options: [.prettyPrinted]) {
                do {
                    let user = try JSONDecoder().decode(CurrentUser.self, from: jsonData)
                    APP_DEL.currentUser = user
                    return true
                } catch {
                    return false
                }
            }
        }
        return false
    }
    
    //MARK: Set AppRoot
    func setAppRoot() {
        if APP_DEL.isLoggedInUserFound() {
            if APP_DEL.currentUser?.is_email_verify == "1" {
                let tab = TABBAR().getTabBar()
                APP_DEL.setRootWindow(vc: tab, isNavigation: true)
            }else{
                let vc : LogInVC = STB.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                APP_DEL.setRootWindow(vc: vc, isNavigation: true)
            }
        } else {
            let vc : LogInVC = STB.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            APP_DEL.setRootWindow(vc: vc, isNavigation: true)
        }
    }
    
    //MARK: set Root Window
    func setRootWindow(vc: UIViewController, isNavigation: Bool) {
        if #available(iOS 13.0, *) {
            APP_DEL.window = UIApplication.shared.windows.first
            APP_DEL.window?.rootViewController = isNavigation ? UINavigationController(rootViewController: vc) : vc
            APP_DEL.window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
            APP_DEL.window = UIWindow(frame: UIScreen.main.bounds)
            APP_DEL.window?.rootViewController = isNavigation ? UINavigationController(rootViewController: vc) : vc
            APP_DEL.window?.makeKeyAndVisible()
        }
    }
    
}


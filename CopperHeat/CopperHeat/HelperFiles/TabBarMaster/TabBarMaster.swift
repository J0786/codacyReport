//
//  TabBarMaster.swift
//
//
//
//  Copyright © 2022 All rights reserved.
//

import UIKit

fileprivate struct TabItemVC {
     var vc: UIViewController
     var title: String
     var selected_image: String
     var normal_image: String
}



var lastSelTabIndex = 0

class TabBarMaster: UITabBarController, UIGestureRecognizerDelegate {
     
     fileprivate var arrTabItemVC: [TabItemVC] = []
     fileprivate var arrNavVC: [UIViewController] = [] // UINavigationController
     override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
     }
     override var selectedIndex: Int { // Mark 1
          
          didSet {
               guard let selectedViewController = viewControllers?[selectedIndex] else { return }
               if IS_IPAD == true {
                   selectedViewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
               } else {
                   selectedViewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12.0)], for: .normal)
               }
          }
     }
     
     override var selectedViewController: UIViewController? { // Mark 2
          didSet {
               
               guard let viewControllers = viewControllers else { return }
               for viewController in viewControllers {
                    if viewController == selectedViewController {
                         if IS_IPAD == true {
                             viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
                         } else {
                             viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12.0)], for: .normal)
                         }
                    } else {
                         if IS_IPAD == true {
                             viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
                         } else {
                             viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12.0)], for: .normal)

                         }
                    }
               }
          }
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          self.navigationController?.setNavigationBarHidden(true, animated: false)
          // Do any additional setup after loading the view.
          self.delegate = self
          
     }
     
     override func viewDidAppear(_ animated: Bool) {
          
          super.viewDidAppear(animated)
          
     }

     public func addVC(vc: UIViewController, title: String, selected_image: String, normal_image: String) {
          
          self.arrTabItemVC.append(TabItemVC(vc: vc, title: title, selected_image: selected_image, normal_image: normal_image))
     }
     
     public func getTabBar(selected_index: Int, selected_color: UIColor, normal_color: UIColor) -> UITabBarController {
          
          self.tabBar.tintColor = selected_color
          self.tabBar.unselectedItemTintColor = normal_color
          
          for tabItem in self.arrTabItemVC {
               self.arrNavVC.append(tabItem.vc) // UINavigationController(rootViewController: tabItem.vc)
          }
          self.viewControllers = self.arrNavVC
          
          
          let tabBar: UITabBar = self.tabBar
          for i in 0..<(tabBar.items ?? []).count {
               
               let tabBarItem: UITabBarItem = tabBar.items![i]
               let tab = self.arrTabItemVC[i]
               
               tabBarItem.image = UIImage(named: tab.normal_image) ?? UIImage()
               tabBarItem.title = tab.title
               if IS_IPAD {
                   tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
               } else {
                   tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12.0)], for: .normal)
               }
          }
          
          self.selectedIndex = selected_index
          
         self.tabBar.barTintColor = UIColor.colorRed
         self.tabBar.backgroundColor = .black
          self.tabBar.layer.borderWidth = 0.0
          self.tabBar.layer.borderColor = UIColor.clear.cgColor
          self.tabBar.layer.shadowColor = UIColor.black.cgColor
          self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
          self.tabBar.layer.shadowOpacity = 0.22
          self.tabBar.layer.shadowRadius = 10.0
          self.tabBar.layer.shadowPath = UIBezierPath(rect: self.tabBar.bounds).cgPath
          self.tabBar.layer.masksToBounds = false
          
          
          if #available(iOS 15.0, *) {
               let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
               tabBarAppearance.configureWithOpaqueBackground()
               
               tabBarAppearance.backgroundColor = .black
               
               
               var tab_font = UIFont()
              tab_font = UIFont.systemFont(ofSize: 12.0)
               
               tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: tab_font, .foregroundColor: normal_color]
               tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: tab_font, .foregroundColor: normal_color]
               tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: tab_font, .foregroundColor: normal_color]

               tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: tab_font, .foregroundColor: selected_color]
               tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: tab_font, .foregroundColor: selected_color]
               tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: tab_font, .foregroundColor: selected_color]

               tabBar.tintColor = selected_color
               
               tabBar.scrollEdgeAppearance = tabBar.standardAppearance
               
               tabBar.standardAppearance = tabBarAppearance
               tabBar.scrollEdgeAppearance = tabBarAppearance
               
          }
          
          UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selected_color], for: .selected)
          
          UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normal_color], for: .normal)

          
          
          return self
     }
     
     
     
}

extension TabBarMaster: UITabBarControllerDelegate {
     
     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
          
          let arrVC = tabBarController.viewControllers ?? []
          let selIndex = arrVC.firstIndex(of: viewController)!
          
          return true
     }
     
     override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
          
     }
}

class TABBAR {
     
    func getTabBar(selected_index: Int = 0) -> UITabBarController {
        let tabbar = TabBarMaster()
        
        let home : HomeVC = STB.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let more : MenuVC = STB.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        
        tabbar.addVC(vc: home, title: "Home", selected_image: "home", normal_image: "home")
        
        tabbar.addVC(vc: more, title: "More", selected_image: "more", normal_image: "more")
        
        let tab = tabbar.getTabBar(selected_index: selected_index, selected_color: .colorRed, normal_color: .white)
        
        return tab
    }
}



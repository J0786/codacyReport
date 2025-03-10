//
//  TabBarMaster.swift
//
//
//
//  Copyright © 2022 All rights reserved.
//

import UIKit

private struct TabItemVC {
     var viewController: UIViewController
     var title: String
     var selectedImage: String
     var normalImage: String
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
               if isIPAD == true {
                   selectedViewController.tabBarItem.setTitleTextAttributes(
                    [.font: UIFont.systemFont(ofSize: 14.0)],
                    for: .normal
                   )
               } else {
                   selectedViewController.tabBarItem.setTitleTextAttributes(
                    [.font: UIFont.systemFont(ofSize: 12.0)],
                    for: .normal
                   )
               }
          }
     }
     override var selectedViewController: UIViewController? { // Mark 2
          didSet {
               guard let viewControllers = viewControllers else { return }
               for viewController in viewControllers {
                    if viewController == selectedViewController {
                         if isIPAD == true {
                             viewController.tabBarItem.setTitleTextAttributes(
                                [.font: UIFont.systemFont(ofSize: 14.0)],
                                for: .normal
                             )
                         } else {
                             viewController.tabBarItem.setTitleTextAttributes(
                                [.font: UIFont.systemFont(ofSize: 12.0)],
                                for: .normal
                             )
                         }
                    } else {
                         if isIPAD == true {
                             viewController.tabBarItem.setTitleTextAttributes(
                                [.font: UIFont.systemFont(ofSize: 14.0)],
                                for: .normal
                             )
                         } else {
                             viewController.tabBarItem.setTitleTextAttributes(
                                [.font: UIFont.systemFont(ofSize: 12.0)],
                                for: .normal
                             )
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
     public func addVC(viewController: UIViewController, title: String, selectedImage: String, normalImage: String) {
          self.arrTabItemVC.append(
            TabItemVC(
                viewController: viewController,
                title: title,
                selectedImage: selectedImage,
                normalImage: normalImage
            )
          )
     }
     public func getTabBar(selectedIndex: Int, selectedColor: UIColor, normalColor: UIColor) -> UITabBarController {
          self.tabBar.tintColor = selectedColor
          self.tabBar.unselectedItemTintColor = normalColor
          for tabItem in self.arrTabItemVC {
               self.arrNavVC.append(tabItem.viewController) // UINavigationController(rootViewController: tabItem.vc)
          }
          self.viewControllers = self.arrNavVC
          let tabBar: UITabBar = self.tabBar
          for index in 0..<(tabBar.items ?? []).count {
               let tabBarItem: UITabBarItem = tabBar.items![index]
               let tab = self.arrTabItemVC[index]
               tabBarItem.image = UIImage(named: tab.normalImage) ?? UIImage()
               tabBarItem.title = tab.title
               if isIPAD {
                   tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
               } else {
                   tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12.0)], for: .normal)
               }
          }
          self.selectedIndex = selectedIndex
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
              var tabFont = UIFont()
              tabFont = UIFont.systemFont(ofSize: 12.0)
               tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.font: tabFont,
                    .foregroundColor: normalColor
               ]
               tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.font: tabFont,
                    .foregroundColor: normalColor
               ]
               tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.font: tabFont,
                    .foregroundColor: normalColor
               ]
               tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.font: tabFont,
                    .foregroundColor: selectedColor
               ]
               tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.font: tabFont,
                    .foregroundColor: selectedColor
               ]
               tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.font: tabFont,
                    .foregroundColor: selectedColor
               ]
               tabBar.tintColor = selectedColor
               tabBar.scrollEdgeAppearance = tabBar.standardAppearance
               tabBar.standardAppearance = tabBarAppearance
               tabBar.scrollEdgeAppearance = tabBarAppearance
          }
          UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: selectedColor],
            for: .selected
          )
          UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: normalColor],
            for: .normal
          )
          return self
     }
}

extension TabBarMaster: UITabBarControllerDelegate {
     func tabBarController(_ tabBarController: UITabBarController,
                           shouldSelect viewController: UIViewController
     ) -> Bool {
          let arrVC = tabBarController.viewControllers ?? []
          let selIndex = arrVC.firstIndex(of: viewController)!
          return true
     }
     override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
     }
}

class TABBAR {
    func getTabBar(selectedIndex: Int = 0) -> UITabBarController {
        let tabbar = TabBarMaster()
        if let home = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            tabbar.addVC(viewController: home, title: "Home", selectedImage: "home", normalImage: "home")
        }
        if let more = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
            tabbar.addVC(viewController: more, title: "More", selectedImage: "more", normalImage: "more")
        }
        let tab = tabbar.getTabBar(selectedIndex: selectedIndex, selectedColor: .colorRed, normalColor: .white)
        return tab
    }
}

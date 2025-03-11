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

class TabBarController: UITabBarController, UIGestureRecognizerDelegate {
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
         // Old Code
          /* didSet {
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
          }*/
         // New Code
         didSet {
             guard let viewControllers = viewControllers else { return }
             // Determine the font size based on the device type
             let fontSize: CGFloat = isIPAD ? 14.0 : 12.0
             let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]

             for viewController in viewControllers {
                 viewController.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
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
    public func getTabBar(selectedIndex: Int,
                          selectedColor: UIColor,
                          normalColor: UIColor) -> UITabBarController {
        configureTabBarAppearance(selectedColor: selectedColor, normalColor: normalColor)
        setupViewControllers()
        configureTabBarItems(selectedColor: selectedColor, normalColor: normalColor)
        self.selectedIndex = selectedIndex
        return self
    }
    private func configureTabBarAppearance(selectedColor: UIColor, normalColor: UIColor) {
        self.tabBar.tintColor = selectedColor
        self.tabBar.unselectedItemTintColor = normalColor
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
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = .black
            configureTabBarAppearanceAttributes(tabBarAppearance: tabBarAppearance,
                                                selectedColor: selectedColor,
                                                normalColor: normalColor)
            self.tabBar.standardAppearance = tabBarAppearance
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: selectedColor],
                                                         for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: normalColor],
                                                         for: .normal)
    }
    private func configureTabBarAppearanceAttributes(tabBarAppearance: UITabBarAppearance,
                                                     selectedColor: UIColor,
                                                     normalColor: UIColor) {
        let tabFont = UIFont.systemFont(ofSize: 12.0)
        tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.font: tabFont,
            .foregroundColor: normalColor]
        tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = [.font: tabFont,
            .foregroundColor: normalColor]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: tabFont,
            .foregroundColor: normalColor]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: tabFont,
            .foregroundColor: selectedColor]
        tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.font: tabFont,
            .foregroundColor: selectedColor]
        tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = [.font: tabFont,
            .foregroundColor: selectedColor]
    }
    private func setupViewControllers() {
        self.arrNavVC = self.arrTabItemVC.map { $0.viewController }
        self.viewControllers = self.arrNavVC
    }
    private func configureTabBarItems(selectedColor: UIColor, normalColor: UIColor) {
        guard let tabBarItems = self.tabBar.items else { return }
        for (index, tabBarItem) in tabBarItems.enumerated() {
            let tab = self.arrTabItemVC[index]
            tabBarItem.image = UIImage(named: tab.normalImage) ?? UIImage()
            tabBarItem.title = tab.title
            let fontSize: CGFloat = isIPAD ? 14.0 : 12.0
            tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: fontSize)], for: .normal)
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
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
        let tabbar = TabBarController()
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

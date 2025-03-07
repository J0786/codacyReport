//
//  SplashVC.swift
//  CopperHeat
//
//  Created by vtadmin on 04/10/24.
//

import UIKit
import Supabase

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SupabaseManager.shared.fetchGeneralData { res , err  in
            if res != nil {
                APP_DEL.dictGenData = res?.first
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            APP_DEL.setAppRoot()
        })
    }
    
}



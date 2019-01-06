//
//  TransitionViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 1/2/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import UIKit
import SVProgressHUD

class TransitionViewController: UIViewController {
    override func viewDidLoad() {
        SVProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "homeViewControllerID")
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
        }
    }
}

//
//  UIAlert+Extension.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/11/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController {
    func showAlert(with alertmessage:String, controller: UIViewController) {
        let alertController = UIAlertController(title: "App Alert", message: alertmessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
        }
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
}

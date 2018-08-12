//
//  LoginViewController.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    let controller = UIAlertController()
    var errorString:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        emailField.text = "robin guduru"
//        passwordField.text = "12345"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            //loginButtonTapped()
        }
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showError(hide: true)
    }
    
    func showError(hide:Bool) {
        if !hide {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.errorLblHeightConstraint.constant = 0
                self?.errorLabel.isHidden = false
                self?.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.errorLblHeightConstraint.constant = 25
                self?.errorLabel.isHidden = true
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func isValidCredentilas() -> Bool {
        var isValid = true
        
        if (usernameField.text?.isEmpty)! &&
            (passwordField.text?.isEmpty)! {
            isValid = false
        }
        
        if !isValid {
            errorLabel.text = errorString
            showError(hide: false)
        } else {
            errorLabel.text = ""
            showError(hide: true)
        }
        return isValid
    }

    @IBAction func loginTapped(_ sender: Any) {
        if isValidCredentilas() {
            let username = usernameField.text ?? ""
            let password = usernameField.text ?? ""
            ActivityIndicator.showActivityIndicator(view: self.view)
            
            //WARNING:("currently storing username password in defaults instead of keychain")
            // storing username password in defaults inorder to use later for new token if expired
            UserDefaults.setValue(username, key: .username)
            UserDefaults.setValue(password, key: .password)
            
            let parameters = ["username" : username, "password": password]
            UserAPI.loginUser(params: parameters, completion: { (result) in
                switch result {
                case .success(let token):
                    UserDefaults.setValue(token["access_token"] as Any, key: .access_token)
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    self.controller.showAlert(with: error.localizedDescription, controller: self)
                }
                ActivityIndicator.hideActivityIndicator(view: self.view)
            })
            
        }
    }


}

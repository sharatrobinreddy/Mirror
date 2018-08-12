//
//  RegisterViewController.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    let controller = UIAlertController()
    var errorString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNaviagationbar()
//        usernameTextField.text = "Guest3"
//        passwordTextField.text = "Pass12345"
    }
    func setupNaviagationbar() {
        self.navigationItem.hidesBackButton = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func validateEntries() -> Bool {
        if (usernameTextField.text?.isEmpty)! &&
            (passwordTextField.text?.isEmpty)! &&
            (reEnterPasswordTextField.text?.isEmpty)! {
            errorString = "Empty Field! ,Please enter email and password"
            return false
        }
        if passwordTextField.text != reEnterPasswordTextField.text {
            errorString = "Password Mismatch!"
            return false
        }
        return true
    }
    
    func getNewUser() -> [String: Any] {
        var createNewUser = [String: Any]()
        if let username = usernameTextField.text {
            createNewUser["username"] = username
        }
        if let password = passwordTextField.text {
            createNewUser["password"] = password
        }
        return createNewUser
    }

    @IBAction func registerTapped(_ sender: Any) {
        if validateEntries() {
            let newUser = getNewUser()
            if newUser.count > 0 {
                UserAPI.registerUser(params: newUser, completion: { (result) in
                    switch result {
                    case .success(let user):
                        UserDefaults.setValue(user.Id, key: .userId)
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.controller.showAlert(with: error.localizedDescription, controller: self)
                    }
                })
            }
        } else {
            self.controller.showAlert(with: errorString!, controller: self)
        }
    }
    
}

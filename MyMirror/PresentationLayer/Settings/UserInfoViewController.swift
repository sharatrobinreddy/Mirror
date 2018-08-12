//
//  UserInfoViewController.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import UIKit

enum viewMode {
    case edit
    case display
}
class UserInfoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var magicHashView: UIView!
    @IBOutlet weak var magicNumberView: UIView!
    @IBOutlet weak var userLikableView: UIView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var magicStringTextField: UITextField!
    @IBOutlet weak var magicNumberTextField: UITextField!
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    var mode = viewMode.display as viewMode
    var viewModel = UserInfoViewModel()
    var selectedTextField: UITextField?
    let controller = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviagationbar()
        setUpData()
        setUpViews(mode: .display)
    }
    
    //MARK: Inital Setup
    func setupNaviagationbar() {
        let editButton = UIBarButtonItem.init(title: "Edit",
                                                      style: .plain,
                                                      target:self ,
                                                      action: #selector(barButtonItemPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setUpData() {
        // initial setup of textfields after retriving current user
        usernameTextField.text = viewModel.username
        ageTextField.text = viewModel.age
        heightTextField.text = viewModel.height
        magicStringTextField.text = viewModel.magicHash
        magicNumberTextField.text = viewModel.magicNum
        if viewModel.likesJs == true {
            selectionSwitch.setOn(true, animated: true)
        } else {
            selectionSwitch.setOn(false, animated: true)
        }
        
    }
    
    func setUpViews(mode: viewMode) {
        self.mode = mode
        selectionSwitch.isUserInteractionEnabled = false

        var cgColor = UIColor.clear.cgColor
        if mode == .edit {
            selectionSwitch.isUserInteractionEnabled = true
            cgColor = UIColor.gray.cgColor
        }
        usernameView.layer.borderColor = cgColor
        usernameView.layer.borderWidth = 1.0

        ageView.layer.borderColor = cgColor
        ageView.layer.borderWidth = 1.0

        heightView.layer.borderColor = cgColor
        heightView.layer.borderWidth = 1.0

        magicHashView.layer.borderColor = cgColor
        magicHashView.layer.borderWidth = 1.0

        magicNumberView.layer.borderColor = cgColor
        magicNumberView.layer.borderWidth = 1.0

        userLikableView.layer.borderColor = cgColor
        userLikableView.layer.borderWidth = 1.0

    }
    
    //MARK: IBActions
    @IBAction func logoutTapped(_ sender: Any) {
        let loginVC = UIStoryboard.navControllerFrom(storyboard: .main, withIdentifier: .loginVC)
        self.present(loginVC, animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: Barbutton Actions
    @objc func barButtonItemPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            self.navigationItem.hidesBackButton = true
            sender.title = "Update"
            setUpViews(mode: .edit)

        } else {
            sender.title = "Edit"
            self.navigationItem.hidesBackButton = false
            setUpViews(mode: .display)
            if (selectedTextField != nil) {
                textFieldDidEndEditing(selectedTextField!)
            }
            validateAndUpdate()
        }
    }
    
    //MARK: Class Methods
    func validateAndUpdate() {
        //1. validate if there is any change in any of the textfields
        //2. if YES create dictionary and sync up with backend
        //3. if NO no action is taken
        
        var updateUserInfo = [String:Any]()
        if usernameTextField.text != viewModel.username {
            updateUserInfo[UserObject.username] = usernameTextField.text
        }
        if ageTextField.text! != viewModel.age {
            updateUserInfo[UserObject.age] = Int(ageTextField.text!)
        }
        if heightTextField.text! != viewModel.height {
            let heightInCms = viewModel.convertFeetToCms(feets: heightTextField.text!)
            updateUserInfo[UserObject.height] = Int(heightInCms)
        }
        if magicNumberTextField.text != viewModel.magicNum {
            updateUserInfo[UserObject.magic_number] = magicNumberTextField.text
        }
        if magicStringTextField.text != viewModel.magicHash {
            updateUserInfo[UserObject.magic_hash] = magicStringTextField.text
        }
        if viewModel.likesJs != selectionSwitch.isOn  {
            updateUserInfo[UserObject.like_js] = selectionSwitch.isOn
        }
        
        if updateUserInfo.count > 0 {
            ActivityIndicator.showActivityIndicator(view: self.view)
            
            viewModel.isValidToken(completion: { (isValid) in
                if isValid {
                    self.syncUser(dict: updateUserInfo)
                }
            })
        }
    }
    
    func syncUser(dict:[String: Any]) {
        self.viewModel.syncUserInfo(info: dict,
                                     completion: { (error) in
                                        if (error != nil) {
                                            self.setUpData()
                                        } else {
                                            self.controller.showAlert(with:"Unable to sync user at this time", controller: self)
                                        }
                                        ActivityIndicator.hideActivityIndicator(view: self.view)
                                        self.navigationController?.popViewController(animated: true)
        })
    }
    
   
}

extension UserInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if mode == .display {
            // textfields disabled for editing
            return false
        }
        selectedTextField = textField
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == heightTextField {
            // converting cms to feets and inches
            textField.text = self.viewModel.convertCmsToFeetInches(cms: Int(textField.text!)!)
        } else if textField == ageTextField {
            textField.text = ageTextField.text! + " years"
        }
        selectedTextField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//
//  HomeViewContollerViewController.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var viewModel: HomeViewModel?
    let controller = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing viewModel
        viewModel = HomeViewModel()
        setupNaviagationbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1.check if we user id in defaults
        // 2.if YES fetch user data from local realm DB
        // 3.if NO show login page
        
        let currentUserId = UserDefaults.getInt(.userId)
        if currentUserId != 0 {
            ActivityIndicator.showActivityIndicator(view: self.view)
            viewModel?.retriveUser(id: currentUserId,
                                   completion: { (error) in
                                    if (error != nil) {
                                        self.controller.showAlert(with:"User not retrived", controller: self)
                                    }
                                    ActivityIndicator.hideActivityIndicator(view: self.view)
                                    
            })
        } else {
            showloginScreen()
        }
    }
    
    func setupNaviagationbar() {
        let account = UIBarButtonItem.init(title: "Account",
                                              style: .plain,
                                              target:self ,
                                              action: #selector(userAccountTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = account
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    func showloginScreen() {
        let loginVC = UIStoryboard.navControllerFrom(storyboard: .main,
                                                     withIdentifier: .loginVC)
        self.present(loginVC, animated: true, completion: nil)
    }
    
    //MARK: IBActions
    @objc func userAccountTapped(_ sender: UIBarButtonItem) {
        let accountVC = UIStoryboard.viewControllerFrom(storyboard: .main,
                                                        withIdentifier: .userInfoVC) as! UserInfoViewController
        accountVC.viewModel.currentUser = (viewModel?.currentUser)!
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
}

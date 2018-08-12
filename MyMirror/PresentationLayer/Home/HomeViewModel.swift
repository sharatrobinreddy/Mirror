//
//  HomeViewModel.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/11/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class HomeViewModel {
    var currentUser: User?
    
    func retriveUser(id: Int, completion: @escaping (Error?) -> Void) {
        
        // 1.open realm
        // 2.check if we user obj
        // 3.if YES make it as current user Else fetch from API
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        if user.count > 0 {
            currentUser = user.first
            completion(nil)
        } else {
            UserAPI.getUser(for: id) { (result) in
                switch result {
                case .success(let user):
                    self.currentUser = user
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
    }
}

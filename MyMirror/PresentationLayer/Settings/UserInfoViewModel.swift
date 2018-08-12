//
//  UserInfoViewModel.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/11/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation

class UserInfoViewModel {
    let INCH_IN_CM: Float = 2.54
    
    var currentUser = User()
    
    var username: String {
        return currentUser.username
    }
    var age: String {
        return "\(currentUser.age) years"
    }
    var height: String {
        let height = convertCmsToFeetInches(cms: currentUser.height)
        return height
    }
    var magicNum: String {
        return String(currentUser.magic_number)
    }
    var magicHash: String {
        return currentUser.magic_hash
    }
    var likesJs: Bool {
        return currentUser.likes_javascript
    }
    
    func isValidToken(completion: @escaping (Bool) -> Void) {
        //check if the token is valid
        // If NO get the new Token to make successful API Calls
        UserAPI.isTokenExpired(for: UserDefaults.getInt(.userId), completion: { (isValid) in
            if isValid {
                completion(true)
            } else {
                UserAPI.refreshToken(completion: { (newToken) in
                    if newToken {
                        completion(true)
                    }
                })
            }
        })
    }
    
    //MARK: API Calls
    func syncUserInfo(info: [String: Any],
                      completion: @escaping (Error?) -> Void) {
        UserAPI.updateUserInfo(for: UserDefaults.getInt(.userId), params: info) { (result) in
            switch result {
            case .success(let updateUser):
                self.currentUser = updateUser
                completion(nil)
            case .failure(let error):
                print(error.localizedDescription)
                completion(error)
            }
        }
    }
    
    //MARK: Helper Methods
    internal func convertCmsToFeetInches(cms: Int) -> String {
        var heightInfeet = "0' 0"
        if cms > 0 {
            let numInches = roundf(Float(cms) / INCH_IN_CM)
            let feet = Int(numInches / 12)
            let inches = Int(numInches.truncatingRemainder(dividingBy: 12.0))
            heightInfeet = "\(feet)' \(inches)"
        }
        return heightInfeet
    }
    
    internal func convertFeetToCms(feets: String) -> String {
        let newFeetsStr = feets.removingWhitespaces()
        let array = newFeetsStr.components(separatedBy: "'")
        let feet = Int(array[0])
        let inches = Int(array[1])
        let feetInCms = Int(Float(feet! * 12) * INCH_IN_CM)
        let inchesInCms = Int(Float(inches!) * INCH_IN_CM)
        let totalheightInCms = feetInCms + inchesInCms
        return "\(totalheightInCms)"
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

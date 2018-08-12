//
//  Constants.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation

enum Service {
    case register
    case login
    case getUser
    case syncUser
}
struct HttpMehod {
    static let GET                   = "GET"
    static let POST                  = "POST"
    static let PATCH                 = "PATCH"
}
enum UserDefaultsKey: String {
    case access_token
    case userId
    case username
    case password
}
struct AppURL {
    static let registerAPI           = "https://mirror-ios-test.herokuapp.com/users"
    static let authAPI               = "https://mirror-ios-test.herokuapp.com/auth"
    static let userAPI               = "https://mirror-ios-test.herokuapp.com/users/"
}
struct UserObject {
    static let username              = "username"
    static let password              = "password"
    static let age                   = "age"
    static let height                = "height"
    static let magic_number          = "magic_number"
    static let magic_hash            = "magic_hash"
    static let like_js               = "likes_javascript"

}

// Storyboard name
enum Storyboard: String {
    case main                       = "Main"
}
// Storyboard viewController identifier
enum StoryboardID: String {
    case loginVC                    = "LoginNavigationController"
    case registerVC                 = "RegisterViewController"
    case userInfoVC                 = "UserInfoViewController"

}

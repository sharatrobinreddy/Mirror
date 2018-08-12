//
//  Util+UserDefaults.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation

extension UserDefaults {
    class func setValue(_ value: Any, key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    class func getString(_ forKey: UserDefaultsKey) -> String? {
        if let string = UserDefaults.standard.string(forKey: forKey.rawValue) {
            return string
        }
        return nil
    }
    
    class func getInt(_ forKey: UserDefaultsKey) -> Int {
        return UserDefaults.standard.integer(forKey: forKey.rawValue)
    }
    
    class func getObject(_ forKey: UserDefaultsKey) -> Any? {
        if let object = UserDefaults.standard.object(forKey: forKey.rawValue) {
            return object
        }
        return nil
    }
}

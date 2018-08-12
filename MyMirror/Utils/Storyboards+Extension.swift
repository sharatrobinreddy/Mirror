//
//  Storyboards+Extension.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import UIKit
extension UIStoryboard {

    class func storyboard(withName name: Storyboard) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
    class func navControllerFrom(storyboard: Storyboard,
                                 withIdentifier identifier: StoryboardID) -> UINavigationController {
        let currentStoryboard = self.storyboard(withName: storyboard)
        if let currentNavVC =
            currentStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)
                as? UINavigationController {
            return currentNavVC
        } else {
            fatalError("No Navigation Controller with \(identifier)")
        }
    }
    
    class func viewControllerFrom(storyboard: Storyboard,
                                  withIdentifier identifier: StoryboardID) -> UIViewController {
        let currentStoryboard = UIStoryboard.storyboard(withName: storyboard)
        return currentStoryboard.instantiateViewController(withIdentifier: identifier.rawValue) as UIViewController
    }
}

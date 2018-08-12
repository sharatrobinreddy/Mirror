//
//  Results.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

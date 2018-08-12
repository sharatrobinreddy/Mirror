//
//  User.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class User: Object, Decodable {
    @objc dynamic var Id: Int = 0
    @objc dynamic var username: String = ""
    @objc dynamic var age:Int = 0
    @objc dynamic var height:Int = 0
    @objc dynamic var magic_number:Int = 0
    @objc dynamic var magic_hash: String = ""
    @objc dynamic var likes_javascript: Bool = false

    override static func primaryKey() -> String? {
        return "Id"
    }

    private enum CodingKeys: String, CodingKey {
        case Id = "id"
        case username
        case age
        case height
        case magic_number
        case magic_hash
        case likes_javascript
    }

    convenience init(userid: Int,
                     username: String?,
                     age: Int?,
                     height: Int?,
                     likejavascript: Bool,
                     magicNumber:Int?,
                     magicString: String?) {
        self.init()
        self.Id = userid
        self.username = username ?? "Unkown"
        self.age = age ?? 0
        self.height = height ?? 0
        self.likes_javascript = likejavascript
        self.magic_number = magicNumber ?? 0
        self.magic_hash = magicString ?? ""
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userId = try container.decode(Int.self, forKey: .Id)
        let username = try container.decode(String?.self, forKey: .username)
        let age = try container.decode(Int?.self, forKey: .age)
        let height = try container.decode(Int?.self, forKey: .height)
        let likesJS = try container.decode(Bool.self, forKey: .likes_javascript)
        let magicNum = try container.decode(Int?.self, forKey: .magic_number)
        let magicHash = try container.decode(String?.self, forKey: .magic_hash)
        self.init(userid: userId,
                  username: username,
                  age: age,
                  height: height,
                  likejavascript: likesJS,
                  magicNumber: magicNum,
                  magicString: magicHash)

    }


    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


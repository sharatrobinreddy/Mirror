//
//  UserAPI.swift
//  MyMirror
//
//  Created by Sharat Robin Reddy Guduru on 8/10/18.
//  Copyright © 2018 Sharat Robin Reddy Guduru. All rights reserved.
//

import Foundation
import RealmSwift

class UserAPI {
    private static let _defaultSession = URLSession(configuration: .default)
    private static var _dataTask: URLSessionDataTask?
}

extension UserAPI {
    
    
    static func createRequest(for service:Service,
                              body:[String: Any]?,
                              userId:Int?) -> URLRequest {
        
        //Headers
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        
        //User Url
        var urlString: String?
        if let id = userId {
            urlString = AppURL.userAPI + String(id)
        }
        var request: URLRequest?
        var serviceUrl: URL?
        var httpMethod = HttpMehod.GET
        switch service {
        case .register:
            serviceUrl = URL(string: AppURL.registerAPI)
            httpMethod = HttpMehod.POST
        case .login:
            serviceUrl = URL(string: AppURL.authAPI)
            httpMethod = HttpMehod.POST
        case .getUser:
            serviceUrl = URL(string: urlString!)
            httpMethod = HttpMehod.GET
            let token = "JWT " + UserDefaults.getString(.access_token)!
            headers["Authorization"] = token
        case .syncUser:
            serviceUrl = URL(string: urlString!)
            httpMethod = HttpMehod.PATCH
            let token = "JWT " + UserDefaults.getString(.access_token)!
            headers["Authorization"] = token
        }
        request = URLRequest(url: serviceUrl!)
        request?.allHTTPHeaderFields = headers
        request?.httpMethod = httpMethod

        if let params = body {
            let jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                request?.httpBody = jsonData
            } catch {
                print("Error: cannot create JSON from todo")
            }
        }
        
        return request!
    }
    
    //MARK: Authentication Methods
    static func registerUser(params:[String: Any]?, completion: @escaping((Result<User>) -> Void)) {
        let request: URLRequest = createRequest(for: .register, body: params, userId: nil)

        _dataTask = _defaultSession.dataTask(with: request,
                                             completionHandler: { (data, response, error) in
                                                defer { self._dataTask = nil }
                                                let result = processApiRequest(data: data, error: error)
                                                OperationQueue.main.addOperation {
                                                    completion(result)
                                                }
        })
        _dataTask?.resume()
    }
    
    static func loginUser(params:[String: Any]?, completion: @escaping((Result<[String: Any]>) -> Void)) {
        
        let request: URLRequest = createRequest(for: .login, body: params, userId: nil)


        _dataTask = _defaultSession.dataTask(with: request,
                                             completionHandler: { (data, response, error) in
                                                defer { self._dataTask = nil }
                                                let result = processAuthRequest(data: data, error: error)
                                                OperationQueue.main.addOperation {
                                                    completion(result)
                                                }
        })
        _dataTask?.resume()
    }
    
    //MARK: Genral Endpoints
    static func getUser(for id:Int, completion: @escaping((Result<User>) -> Void)) {
        
        let request: URLRequest = createRequest(for: .getUser, body: nil, userId: id)

        _dataTask = _defaultSession.dataTask(with: request,
                                             completionHandler: { (data, response, error) in
                                                defer { self._dataTask = nil }
                                                let result = processApiRequest(data: data, error: error)
                                                OperationQueue.main.addOperation {
                                                    completion(result)
                                                }
        })
        _dataTask?.resume()
    }
    
    static func updateUserInfo(for id:Int,
                               params:[String: Any]?,
                               completion: @escaping((Result<User>) -> Void)) {
        
        let request: URLRequest = createRequest(for: .syncUser, body: params, userId: id)

        _dataTask = _defaultSession.dataTask(with: request,
                                             completionHandler: { (data, response, error) in
                                                defer { self._dataTask = nil }
                                                let result = processApiRequest(data: data, error: error)
                                                OperationQueue.main.addOperation {
                                                    completion(result)
                                                }
        })
        _dataTask?.resume()
    }
    
    
    //MARK: Check Token
    static func isTokenExpired(for id:Int, completion: @escaping((Bool) -> Void)) {
        let request: URLRequest = createRequest(for: .getUser, body: nil, userId: id)
        
        _dataTask = _defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
            defer { self._dataTask = nil }
            let result = processAuthRequest(data: data, error: error)
            switch result {
            case .success(let obj):
                if let error:String = obj["error"] as? String,
                    error == "Invalid token" {
                    completion(false)
                } else {
                    completion(true)
                }
            case .failure( _):
                completion(false)
            }
            
        })
        _dataTask?.resume()
    }
    
    static func refreshToken(completion: @escaping((Bool) -> Void)) {
        let parameters = ["username": UserDefaults.getString(.username)!, "password":  UserDefaults.getString(.password)!] as [String: Any]
        
        self.loginUser(params: parameters) { (result) in
            switch result {
            case .success(let token):
                print(token["access_token"] as Any)
                UserDefaults.setValue(token["access_token"] as Any, key: .access_token)
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    //MARK: Process Requests
    static func processApiRequest( data: Data?, error: Swift.Error?) -> Result<User> {
        
        if let error = error {
            return .failure(Error.requestFailed(reason: error.localizedDescription))
        }
        
        guard let responsdata = data else {
            return .failure(Error.noData)
        }
        let decoder = JSONDecoder()
        
        do {
            let user = try decoder.decode(User.self, from: responsdata)
            
            DispatchQueue.main.async {
                let realm = try! Realm()
                try! realm.write {
                    realm.add(user, update: true)
                }
            }
            return .success(user)
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
            return .failure(Error.requestFailed(reason: context.debugDescription))

        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return .failure(Error.requestFailed(reason: context.debugDescription))

        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return .failure(Error.requestFailed(reason: context.debugDescription))

        } catch DecodingError.typeMismatch(let type, let context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return .failure(Error.requestFailed(reason: context.debugDescription))

        } catch {
            return .failure(Error.jsonSerializationFailed(reason: "Failed to convert data to JSON"))
        }
        
    }
    
    static func processAuthRequest( data: Data?, error: Swift.Error?) -> Result<[String: Any]> {
        
        if let error = error {
            return .failure(Error.requestFailed(reason: error.localizedDescription))
        }
        
        guard let responsdata = data else {
            return .failure(Error.noData)
        }
        do {
            let user = try JSONSerialization.jsonObject(with: responsdata, options: []) as! [String: Any]
            return .success(user)
        } catch {
            return .failure(Error.jsonSerializationFailed(reason: "Failed to convert data to JSON"))
        }
    }
}


// MARK: - Error Definitions
extension UserAPI {
    
    enum Error: Swift.Error {
        case noData
        case jsonSerializationFailed(reason: String)
        case requestFailed(reason: String)
    }
}

extension UserAPI.Error: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data returned with response"
        case .jsonSerializationFailed(let reason):
            return reason
        case .requestFailed(let reason):
            return reason
        }
    }
}

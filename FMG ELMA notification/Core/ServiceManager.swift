//
//  ServiceManager.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/16/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit
import Alamofire

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    //http://178.134.55.18:8520/api/login?user=admin&pass=fmg0101
    func loginUser(userName: String, password: String, completion: @escaping (Bool, Int) -> ())  {
        let hostName = UsersDefaultsManager.getSavedHost()
        let portnName = UsersDefaultsManager.getSavedPort()
        if hostName != nil && portnName != nil && hostName != "" && portnName != "" {
            Alamofire.request("http://\(hostName!):\(portnName!)/api/login?user=\(userName)&pass=\(password)").responseJSON { (response) in
                if let result = response.result.value as? Int {
                    DispatchQueue.main.async {
                        //Result is user id if -1 not exist user
                        print(result)
                        if result == -1 {
                            completion(false,result)
                        } else {
                            completion(true,result)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false,-1)
                    }
                }
            }
        } else {
            completion(false,-2)
        }
    }
    
    func getUserName(userId: Int, completion: @escaping (String) -> ())  {
        let hostName = UsersDefaultsManager.getSavedHost()
        let portnName = UsersDefaultsManager.getSavedPort()
        Alamofire.request("http://\(hostName!):\(portnName!)/api/Emploee?id=\(userId)").responseJSON { (response) in
            if let result = response.result.value as? [Dictionary<String,Any>] {
                DispatchQueue.main.async {
                    if result.count > 0 {
                        completion(result.first!["FullName"] as! String)
                    } else {
                        completion("")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion("")
                }
            }
        }
    }
    
    func getTODOListBuyUser(userId: Int, listStatus: Int, completion: @escaping ([TODOModel]) -> ()) {
        let hostName = UsersDefaultsManager.getSavedHost()
        let portnName = UsersDefaultsManager.getSavedPort()
        Alamofire.request("http://\(hostName!):\(portnName!)/api/GetMessages?idUser=\(userId)&status=\(listStatus)").responseJSON { (response) in
            if let result = response.result.value as? [Dictionary<String,Any>] {
                DispatchQueue.main.async {
                    if result.count > 0 {
//                        completion(result.first!["FullName"] as! String)
                        var list = Array<TODOModel>()
                        for obj in result {
                            let toDomodel = TODOModel()
                            toDomodel.message = obj["message"] as? String
                            toDomodel.IdMessagesForAndorid = obj["IdMessagesForAndorid"] as? Int
                            toDomodel.DataEnd = obj["DataEnd"] as! String
                            toDomodel.DataStart = obj["DataStart"] as! String
                        }
                        completion(list)
                    } else {
                        completion([])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}

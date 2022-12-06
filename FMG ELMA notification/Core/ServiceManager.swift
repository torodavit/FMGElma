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
            AF.request("http://\(hostName!):\(portnName!)/api/login?user=\(userName)&pass=\(password)").response { (response) in
                switch response.result {
                case .success(let data):
                    let str = String(data: data!, encoding: .utf8)
                    if let idUser = Int(str!) {
                        DispatchQueue.main.async {
                            completion(true,idUser)
                        }
                    }else{
                        DispatchQueue.main.async {
                            completion(false,-1)
                        }
                    }
             
                case .failure(_):
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
        AF.request("http://\(hostName!):\(portnName!)/api/Emploee?id=\(userId)").response { (response) in
            
            switch response.result {
            case .success(let data):
                do {
                    let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: Any]]
                    if myJson.count > 0 {
                        completion(myJson.first!["FullName"] as! String)
                    } else {
                        completion("")
                    }
                } catch let error {
                    completion("")
                }
         
            case .failure(_):
                DispatchQueue.main.async {
                    completion("")
                }
            }
        }
    }
    
    func getTODOListBuyUser(userId: Int, listStatus: Int, completion: @escaping ([TODOModel]) -> ()) {
        let hostName = UsersDefaultsManager.getSavedHost()
        let portnName = UsersDefaultsManager.getSavedPort()
        AF.request("http://\(hostName!):\(portnName!)/api/GetMessages?idUser=\(userId)&status=\(listStatus)").response { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: Any]]
                    DispatchQueue.main.async{
                        if myJson.count > 0 {
                            var list = Array<TODOModel>()
                            for obj in myJson {
                                let toDomodel = TODOModel()
                                toDomodel.message = obj["Message"] as? String
                                toDomodel.IdMessagesForAndorid = obj["IdMessagesForAndorid"] as? Int
                                toDomodel.DataEnd = obj["DataEnd"] as? String
                                toDomodel.DataStart = obj["DataStart"] as? String
                                toDomodel.IdUser = obj["IdUser"] as? Int
                                toDomodel.Seen = obj["Seen"] as? Int
                                toDomodel.Msglink = obj["Msglink"] as? String
                                toDomodel.SeenDate = obj["SeenDate"] as? String
                                list.append(toDomodel)
                            }
                            completion(list)
                        } else {
                            completion([])
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
         
            case .failure(_):
                DispatchQueue.main.async {
                    completion([])
                }
            }

        }
    }
    
    func seenToDo(with toDoId: Int, completion: @escaping (String) -> ()) {
        //http://178.134.55.18:8520/api/MessageSeen?IdMessagesForAndorid=10
        let hostName = UsersDefaultsManager.getSavedHost()
        let portnName = UsersDefaultsManager.getSavedPort()
        AF.request("http://\(hostName!):\(portnName!)/api/MessageSeen?IdMessagesForAndorid=\(toDoId)").response { (response) in
            switch response.result {
            case .success(let data):
                do {
                    if let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? String{
                        completion(myJson)
                    }else{
                        completion("")
                    }
                } catch let error {
                    completion("")
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion("")
                }
            }
        }
    }
}

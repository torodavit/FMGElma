//
//  UsersDefaultsManager.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/16/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit

class UsersDefaultsManager: NSObject {
    static func getSavedHost() -> String?{
        let userDefaults = UserDefaults.standard
        let host = userDefaults.object(forKey: "urlhost") as? String
        return host ?? "217.147.235.106"
    }
    
    static func saveHost(hostName: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(hostName, forKey: "urlhost")
        userDefaults.synchronize()
    }
    
    static func getSavedPort() -> String?{
        let userDefaults = UserDefaults.standard
        let port = userDefaults.object(forKey: "portname") as? String
        return port ?? "8001"
    }
    
    static func savePort(portName: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(portName, forKey: "portname")
        userDefaults.synchronize()
    }
    
    static func getSavedUserName() -> String?{
        let userDefaults = UserDefaults.standard
        let userName = userDefaults.object(forKey: "savedusername") as? String
        return userName
    }
    
    static func saveUserName(userName: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userName, forKey: "savedusername")
        userDefaults.synchronize()
    }
    
    static func getSavedUserPass() -> String?{
        let userDefaults = UserDefaults.standard
        let userPass = userDefaults.object(forKey: "saveduserpass") as? String
        return userPass
    }
    
    static func saveUserPass(userPass: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userPass, forKey: "saveduserpass")
        userDefaults.synchronize()
    }
    
    static func getNeedSaveUser() -> Bool{
        let userDefaults = UserDefaults.standard
        let userPass = userDefaults.bool(forKey: "needsaveuser")
        return userPass
    }
    
    static func needSaveUser(needSave: Bool){
        let userDefaults = UserDefaults.standard
        userDefaults.set(needSave, forKey: "needsaveuser")
        userDefaults.synchronize()
    }
}

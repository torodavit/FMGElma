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
        return host
    }
    
    static func saveHost(hostName: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(hostName, forKey: "urlhost")
        userDefaults.synchronize()
    }
    
    static func getSavedPort() -> String?{
        let userDefaults = UserDefaults.standard
        let port = userDefaults.object(forKey: "portname") as? String
        return port
    }
    
    static func savePort(portName: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(portName, forKey: "portname")
        userDefaults.synchronize()
    }
}

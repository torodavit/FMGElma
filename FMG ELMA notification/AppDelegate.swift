//
//  AppDelegate.swift
//  FMG ELMA notification
//
//  Created by Tornike Davitashvili on 11/14/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //653f176c-ad19-4227-b15f-4a7b095ef78a
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("653f176c-ad19-4227-b15f-4a7b095ef78a")
        
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]  {
            
            if let customUserInfo =  userInfo["custom"] as? [String: Any] {
                if let id = customUserInfo["a"]! as? [String: Any]{
                    if let idString = id["id"] as? String {
                        print(idString)
                        ServiceManager.shared.seenToDo(with: Int(idString)!) { (success) in
                            print(success)
                        }
                    }
                }
            }
            // Do what you want to happen when a remote notification is tapped.            
        }
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let customUserInfo =  userInfo["custom"] as? [String: Any] {
            if let id = customUserInfo["a"]! as? [String: Any]{
                if let idString = id["id"] as? String {
                    print(idString)
                    ServiceManager.shared.seenToDo(with: Int(idString)!) { (success) in
                        print(success)
                    }
                }
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


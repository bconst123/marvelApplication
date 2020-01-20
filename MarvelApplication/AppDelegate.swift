//
//  AppDelegate.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("You are in marvel app ... \(url)")
        
        let urlString = url.absoluteString
        let resultArray = urlString.components(separatedBy: "://")
        let result = Int(resultArray[1]) ?? 0
        if(resultArray[1] == "0" || resultArray[1] == "1" || resultArray[1] == "2") {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc1 = storyboard.instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
            vc1.characterViewModel.favoriteCharactersArray = vc1.retrieveFromUserDefaults()
            print(vc1.characterViewModel.favoriteCharactersArray.count)
            if(vc1.characterViewModel.favoriteCharactersArray.count - 1 < result) {
                print("There are no favorite - \(result+1) Character at the index ...")
                return true
            }
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            vc.delegate = vc1
            vc.completionHandler = {return CharacterModelFav(character: vc1.characterViewModel.favoriteCharactersArray[result], favorite: true)}

            if let tabBarController = self.window?.rootViewController as? UITabBarController, let navController = tabBarController.selectedViewController as? UINavigationController {
                    navController.pushViewController(vc, animated: true)
            }
        }
        return true
    }
}

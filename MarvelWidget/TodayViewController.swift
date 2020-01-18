//
//  TodayViewController.swift
//  MarvelWidget
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let result = UserDefaults.standard.dictionary(forKey: "WidgetInfo")
        if let result2 = result {
            for each in result2 {
                print("\(each.key)  ::: \(each.value)")
            }
        }
        // Do any additional setup after loading the view.
    }
        
    @IBAction func goToFirstCharacter(_ sender: Any) {

        if let appURL = URL(string: "marvelapp://0") {
            extensionContext?.open(appURL, completionHandler: nil)
        }
    }
    
    @IBAction func goToSecondCharacter(_ sender: Any) {
        if let appURL = URL(string: "marvelapp://1") {
            extensionContext?.open(appURL, completionHandler: nil)
        }
    }
    
    @IBAction func goToThirdCharacter(_ sender: Any) {
        if let appURL = URL(string: "marvelapp://2") {
            extensionContext?.open(appURL, completionHandler: nil)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

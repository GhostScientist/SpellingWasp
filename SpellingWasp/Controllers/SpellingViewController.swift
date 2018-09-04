//
//  ViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 7/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import GameplayKit
import Alamofire

class SpellingViewController: UIViewController {
    
    var numberOfWordsToPresent: Int!
    
    let baseAPIURL = "https://od-api.oxforddictionaries.com/api/v1/entries/en/"
    var apiKey = ""
    var appID = ""
    
    // MARK: Interface Builder Connections
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveKeys()
        
    }
    
    func retrieveKeys() {
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let url = URL(fileURLWithPath: path)
            keys = NSDictionary(contentsOf: url)
        }
        if let dict = keys {
            apiKey = dict["oxfordAppKey"] as! String
            appID = dict["oxfordAppID"] as! String
        }
    }
}




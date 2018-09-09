//
//  Networker.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/9/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Networker {
    
    // MARK: - Instance variables
    internal let baseURL: URL
    internal let session = URLSession.shared
    internal let appID: String
    internal let appKey: String
    
    // MARK: - Class Constructor
    public static let shared: Networker = {
        let file = Bundle.main.path(forResource: "Keys", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: file)!
        let urlString = dict["api_URL"] as! String
        let app_ID = dict["oxfordAppID"] as! String
        let app_Key = dict["oxfordAppKey"] as! String
        let url = URL(string: urlString)!
        return Networker(baseURL: url, appID: app_ID, appKey: app_Key)
    }()
    
    private init(baseURL: URL, appID: String, appKey: String) {
        self.baseURL = baseURL
        self.appID = appID
        self.appKey = appKey
    }
    
    public func grabWordInfo(word: String) {
        let url = baseURL.appendingPathComponent(word)
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Networker.shared.appID, forHTTPHeaderField: "app_id")
        request.addValue(Networker.shared.appKey, forHTTPHeaderField: "app_key")
        
        _ = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let response = response, let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                print(response)
                print(jsonData)
            } else {
                print(error)
            }
        }).resume()
    }
}

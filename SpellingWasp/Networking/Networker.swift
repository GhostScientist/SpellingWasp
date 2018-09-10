//
//  Networker.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/9/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NetworkerDelegate {
    func buildWord(_ json: JSON)
}

public final class Networker {
    
    // MARK: - Instance variables
    internal let baseURL: URL
    internal let session = URLSession.shared
    internal let appID: String
    internal let appKey: String
    var networkerDelegate: NetworkerDelegate!
    
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
    
    public func grabWordInfo(word: String) -> JSON? {
        let url = baseURL.appendingPathComponent(word)
        var request = URLRequest(url: url)
        var jsonStuff: JSON?
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Networker.shared.appID, forHTTPHeaderField: "app_id")
        request.addValue(Networker.shared.appKey, forHTTPHeaderField: "app_key")
        
        _ = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                do {
                    let json = try JSON(data: data!)
                    self.networkerDelegate.buildWord(json)
                } catch {
                    print("Building JSON failed due to \(error.localizedDescription)")
                }
            } else {
                print(error?.localizedDescription)
            }
        }).resume()
        
        if let json = jsonStuff {
            return json
        }
        return nil
    }
}

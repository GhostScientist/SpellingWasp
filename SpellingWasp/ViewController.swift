//
//  ViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 7/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    let baseAPIURL = "https://od-api.oxforddictionaries.com/api/v1/en/"
    var apiKey = ""
    var appID = ""
    
    @IBOutlet weak var exampleOutlet: UIButton!
    @IBOutlet weak var repeatOutlet: UIButton!
    @IBOutlet weak var solveOutlet: UIButton!
    @IBOutlet weak var skipOutlet: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordField: UILabel!
    @IBOutlet weak var wordDataLabel: UILabel!
    
    var wordsToPresent = [Word]()
    var wordsPresented = [Word]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveKeys()
        exampleOutlet.clipsToBounds = true
        exampleOutlet.layer.cornerRadius = 12.0
        repeatOutlet.clipsToBounds = true
        repeatOutlet.layer.cornerRadius = 12.0
        solveOutlet.clipsToBounds = true
        solveOutlet.layer.cornerRadius = 62.5
        skipOutlet.clipsToBounds = true
        skipOutlet.layer.cornerRadius = 62.5

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
    
    @IBAction func exampleTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func solveTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        
    }
    
    func replaceWordWithUnderscore(word: String) -> String {
        var finalWord = ""
        for _ in word {
            finalWord += "_ "
        }
        return finalWord
    }
    
    func loadWordsFromAPI(_ number: Int) {
        
    }
}


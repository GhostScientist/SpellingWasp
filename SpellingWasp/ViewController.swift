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

class ViewController: UIViewController {
    
    let baseAPIURL = "https://od-api.oxforddictionaries.com/api/v1/entries/en/"
    var apiKey = ""
    var appID = ""
    
    let testWord = "Cavort"
    
    @IBOutlet weak var exampleOutlet: UIButton!
    @IBOutlet weak var repeatOutlet: UIButton!
    @IBOutlet weak var solveOutlet: UIButton!
    @IBOutlet weak var skipOutlet: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordField: UILabel!
    @IBOutlet weak var wordDataLabel: UILabel!
    
    var wordsToPresent = [Word]()
    var wordsPresented = [Word]()
    var currentWord = Word(word: "Temp", group: "Temp Group", origin: "Temp Origin", exampleOfUsage: "Hello, World", pronunciation: "Nil")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveKeys()
        shuffleWordsToBePresentedArray()
        loadWordsFromAPI(50)
        exampleOutlet.clipsToBounds = true
        exampleOutlet.layer.cornerRadius = 12.0
        repeatOutlet.clipsToBounds = true
        repeatOutlet.layer.cornerRadius = 12.0
        solveOutlet.clipsToBounds = true
        solveOutlet.layer.cornerRadius = 62.5
        skipOutlet.clipsToBounds = true
        skipOutlet.layer.cornerRadius = 62.5

    }
    
    func shuffleWordsToBePresentedArray() {
        wordsToPresent = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: wordsToPresent) as! [Word]
    }
    
    func parse(_ json: JSON) {
        for result in json["results"].arrayValue {
            let word = result["id"].stringValue
            print("hello, the word we're looking at is \(word)")
        }
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
        let thisIsATest = "The quick brown fox jumped over the lazy dog."
        var utterance = AVSpeechUtterance(string: thisIsATest)
        var synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        var synth = AVSpeechSynthesizer()
        synth.speak(AVSpeechUtterance(string: currentWord.word))
    }
    
    @IBAction func solveTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        
    }
    
    func sendRequestToAPIFor(word: String) {
        let word_id = word.lowercased()
        let url = URL(string: baseAPIURL + word_id)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appID, forHTTPHeaderField: "app_id")
        request.addValue(apiKey, forHTTPHeaderField: "app_key")
        
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let response = response, let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                let json = JSON(data)
                self.buildWordObjectFrom(json)
            } else {
                print(error)
                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        }).resume()
    }
    
    func buildWordObjectFrom(_ myJSON: JSON) -> Word {
        var wordToReturn = Word(word: "Temp", group: "Temp", origin: "Temp", exampleOfUsage: "Temp", pronunciation: "Temp")
        for result in myJSON["results"].arrayValue {
            let word = result["id"].stringValue
            let group = result["lexicalEntries"]["entries"]["lexicalCategory"].stringValue
            let origin = result["lexicalEntries"]["entries"]["etymologies"].stringValue
            let exampleOfUsage = result["lexicalEntries"]["entries"]["senses"]["examples"]["text"].stringValue
            let pronunciationPath = result["lexicalEntries"]["pronunciations"]["audioFile"].stringValue
            wordToReturn = Word(word: word, group: group, origin: origin, exampleOfUsage: exampleOfUsage, pronunciation: pronunciationPath)
        }
        return wordToReturn
    }
    
    func loadWordsFromAPI(_ number: Int) {
        for i in 0...number {
            sendRequestToAPIFor(word: wordsToPresent[i].word)
        }
    }
}


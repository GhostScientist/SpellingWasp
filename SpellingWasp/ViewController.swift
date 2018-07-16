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

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    
    
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
    
    var stringsLoadedFromTextFile = [String]()
    var wordsToPresent = [Word]()
    var wordsPresented = [Word]()
    var currentWord = Word(word: "Wasp", group: "Noun", origin: "Old English", exampleOfUsage: "Swarms of bees and wasps would also have nested in the forest.", pronunciation: "Nil") {
        didSet {
            wordField.text = currentWord.replaceLettersWithUndscore()
            // It will also play the audio of the clip.
        }
    }
    
    var doneLoadingFromFile = false {
        didSet {
            loadWordsFromAPI()
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveKeys()
        performSelector(inBackground: #selector(loadStringArrayFromTextFile), with: nil)
        exampleOutlet.clipsToBounds = true
        exampleOutlet.layer.cornerRadius = 12.0
        repeatOutlet.clipsToBounds = true
        repeatOutlet.layer.cornerRadius = 12.0
        solveOutlet.clipsToBounds = true
        solveOutlet.layer.cornerRadius = 62.5
        skipOutlet.clipsToBounds = true
        skipOutlet.layer.cornerRadius = 62.5
    }
    
    @objc func loadStringArrayFromTextFile() {
        if let allWordsTextFilePath = Bundle.main.path(forResource: "all_words", ofType: "txt") {
            if let wordsFromFile = try? String.init(contentsOfFile: allWordsTextFilePath) {
                let mixedList = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: wordsFromFile.components(separatedBy: "\n")) as! [String]
                for each in mixedList {
                    if stringsLoadedFromTextFile.count < 30 {
                        if each.count >= 6 {
                            let filteredText = String(each.filter { !" \n\t\r".contains($0) })
                            stringsLoadedFromTextFile.append(filteredText.lowercased())
                        }
                    } else {
                        break
                    }
                }
            }
        }
        stringsLoadedFromTextFile = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: stringsLoadedFromTextFile) as! [String]
        doneLoadingFromFile = true
    }
    
    func shuffleWordsToBePresentedArray() {
        wordsToPresent = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: wordsToPresent) as! [Word]
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
        let utterance = AVSpeechUtterance(string: currentWord.exampleOfUsage)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        let synth = AVSpeechSynthesizer()
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
                //print("THE JSON DATA IS \(jsonData)")
                self.buildWordObjectFrom(json)
            } else {
                print(error)
                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        }).resume()
        
    }
    
    func downloadAudioFileFrom(_ path: URL) {
        // This function will download the word's audio file from the API
        // It will then set the currentAudioFile variable at the top for easy reference/overwriting.
    }
    
    func buildWordObjectFrom(_ myJSON: JSON) {
        var wordToReturn = Word(word: "Temp", group: "Temp", origin: "Temp", exampleOfUsage: "Temp", pronunciation: "Temp")
        for result in myJSON["results"].arrayValue {
            let word = result["id"].stringValue
            let group = result["lexicalEntries"][0]["lexicalCategory"].stringValue
            let origin = result["lexicalEntries"][0]["entries"][0]["etymologies"][0].stringValue
            let exampleOfUsage = result["lexicalEntries"][0]["entries"][0]["senses"][0]["examples"][0]["text"].stringValue
            let pronunciationPath = result["lexicalEntries"][0]["pronunciations"][0]["audioFile"].stringValue
            wordToReturn = Word(word: word, group: group, origin: origin, exampleOfUsage: exampleOfUsage, pronunciation: pronunciationPath)
            print("The word \(wordToReturn.word) is being added to the array")
            wordsToPresent.append(wordToReturn)
        }
    }
    
    @objc func loadWordsFromAPI(_ number: Int = 29) {
        for i in 0...number {
            sendRequestToAPIFor(word: stringsLoadedFromTextFile[i])
        }
        print(wordsToPresent)
    }
}


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
    var currentWord = Word(word: "Wasp", group: "Noun", origin: "Old English", exampleOfUsage: "Swarms of bees and wasps would also have nested in the forest.") {
        didSet {
            print("The word \(currentWord.word) has been set.")
        }
    }
    var doneLoadingFromFile = false {
        didSet {
            loadWordsFromAPI()
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Streak: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordField.adjustsFontSizeToFitWidth = true
        wordField.textAlignment = .center
        wordDataLabel.adjustsFontSizeToFitWidth = true
        wordDataLabel.textAlignment = .center
        retrieveKeys()
        loadStringArrayFromTextFile()
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
                    if stringsLoadedFromTextFile.count < 100 {
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
        GKRandomSource.sharedRandom().arrayByShufflingObjects(in: stringsLoadedFromTextFile) as! [String]
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
        let utterance = AVSpeechUtterance(string: currentWord.word)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func solveTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Solve", message: "Do your best!", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned self] (action) in
            if ac.textFields![0].text!.lowercased() == self.currentWord.word.lowercased() { // If the word the user entered is correct
                self.score += 1
                self.progressToNextWord()
            } else {
                self.progressToNextWord()
                let synth = AVSpeechSynthesizer()
                synth.speak(AVSpeechUtterance(string: "You are incorrect"))
                self.score = 0
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Skip", message: "Are you sure you want to skip?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (action) in
            self.progressToNextWord()
            self.score = 0
        }))
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
    
    func progressToNextWord() {
        wordsToPresent.remove(at: 0)
        currentWord = wordsToPresent[0]
        wordField.text = currentWord.replaceLettersWithUnderscore()
        wordDataLabel.text = currentWord.returnDescriptiveStringFor()
        if wordsToPresent.count < 5 {
            loadWordsFromAPI()
        }
    }
    
    func sendRequestToAPIFor(word: String) {
        let url = URL(string: baseAPIURL + word)!
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
                //print(error)
                //print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        }).resume()
        
    }
    
    func buildWordObjectFrom(_ myJSON: JSON) {
        var wordToReturn = Word(word: "Temp", group: "Temp", origin: "Temp", exampleOfUsage: "Temp")
        for result in myJSON["results"].arrayValue {
            let word = result["id"].stringValue.capitalized
            let group = result["lexicalEntries"][0]["lexicalCategory"].stringValue.capitalized
            let origin = result["lexicalEntries"][0]["entries"][0]["etymologies"][0].stringValue
            let exampleOfUsage = result["lexicalEntries"][0]["entries"][0]["senses"][0]["examples"][0]["text"].stringValue
            wordToReturn = Word(word: word, group: group, origin: origin, exampleOfUsage: exampleOfUsage)
            wordsToPresent.append(wordToReturn)
            print("There are now \(wordsToPresent.count) words in our array.")
            if wordsToPresent.count == 1 {
                currentWord = wordsToPresent[0]
                DispatchQueue.main.async {
                    self.wordField.text = self.currentWord.replaceLettersWithUnderscore()
                    self.wordDataLabel.text = self.currentWord.returnDescriptiveStringFor()
                }
            }
        }
    }
    
    func blacklistIncompleteWordObjects() {
        print("This will keep track of any bad words from the text file")
    }
    
    @objc func loadWordsFromAPI(_ number: Int = 30) {
        for i in 0...number {
            sendRequestToAPIFor(word: stringsLoadedFromTextFile[i])
            stringsLoadedFromTextFile.remove(at: 0)
            if stringsLoadedFromTextFile.count < 15 {
                loadStringArrayFromTextFile()
            }
        }
    }
}




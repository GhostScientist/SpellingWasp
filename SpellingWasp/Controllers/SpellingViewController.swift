//
//  SpellingViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/5/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit
import SwiftyJSON
import GameplayKit
import AVFoundation

class SpellingViewController: UIViewController, PickerDelegate {
    
    // MARK: - IB Connections
    
    @IBOutlet weak var secretWord: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var repeatOutlet: UIButton!
    @IBOutlet weak var exampleOutlet: UIButton!
    
    
    
    internal var numberOfWordsToPresent: Int? {
        didSet {
            chosenNum = true
        }
    }
    
    internal var chosenNum = false
    
    var wordToPresent: Word? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                if let word = self.wordToPresent {
                    self.speak("Your next word is...\(word.word)")
                    self.secretWord.text = word.convertToUnderscores()
                    self.groupLabel.text = word.classification
                    self.originLabel.text = word.originOfWord
                }
            }
        }
    }
    
    var wordsToPresent = [Word]()
    
    var player: AVPlayer?
    
    var networker: Networker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SpellingWasp"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Solve", style: .plain, target: self, action: #selector(solveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))
        networker = Networker.shared
        networker?.networkerDelegate = self
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if chosenNum == false {
            super.viewDidAppear(animated)
            let vc = storyboard?.instantiateViewController(withIdentifier: "PickerView") as! PickerViewController
            vc.pickerDelegate = self
            present(vc, animated: true)
        } 
    }
    
    func loadUI() {
        title = "SpellingWasp"
        repeatOutlet.layer.cornerRadius = repeatOutlet.frame.height / 2
        exampleOutlet.layer.cornerRadius = exampleOutlet.frame.height / 2 
    }
    
    override func loadView() {
        super.loadView()
        
        //view.backgroundColor = UIColor.white
    }
    
    @objc func solveTapped() {
        // This will present an alert controller with a text field for the user to submit their
        // spelling attempt. If they're correct, it will play a noise and load a "Tap to Continue" screen
        // for when the user is ready.
        
        let ac = UIAlertController(title: "Solve!", message: "Submit your spelling attempt.", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned self] (action) in
            if ac.textFields![0].text!.lowercased() == self.wordToPresent!.word.lowercased() { // If the word the user entered is correct
                self.speak("You are correct. Good job!")
                self.loadWord()
            } else {
                DispatchQueue.main.async {
                    var string = "You are incorrect. The word \(self.wordToPresent!.word) is spelled: "
                    for eachLetter in Array(self.wordToPresent!.word) {
                        string += " \(eachLetter) "
                    }
                    self.speak(string)
                }
                self.loadWord()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func skipTapped() {
        // The user can choose to skip the current word without it counting against their selected goal.
        let ac = UIAlertController(title: "Skip", message: "Are you sure you want to skip?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .default))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (action) in
            self.loadWord()
        }))
        present(ac, animated: true)
    }

    
    func loadWord() {
        print("Loading word...")
        if let wordToLoad = generateWord() {
            print("Loading word: \(wordToLoad)")
            if let json = networker.grabWordInfo(word: wordToLoad) {
                wordToPresent = Word(json: json)
            }
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        // Will play the audio file downloaded from the dictionary.
        if let word = wordToPresent {
            speak(word.word)
        }
    }
    
    @IBAction func exampleTapped(_ sender: UIButton) {
        if let word = wordToPresent {
            speak(word.examplesOfUsage)
        }
    }

    func didTap(num: Int) {
        numberOfWordsToPresent = num
        loadWord()
    }
    
    func speak(_ phrase: String) {
        let utter = AVSpeechUtterance(string: phrase)
        utter.rate = 0.4
        let synth = AVSpeechSynthesizer()
        synth.speak(utter)
    }
    
    func spellWordOut(_ word: String) {
        let array = Array(word)
        for letter in array {
            speak(String(letter))
        }
    }
}

extension SpellingViewController: NetworkerDelegate {
    func generateWord() -> String? {
        if let filePath = Bundle.main.path(forResource: "all_words", ofType: "txt") {
            if let allWords = try? String.init(contentsOfFile: filePath) {
                let mixedList = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords.components(separatedBy: "\n")) as! [String]
                return mixedList[0]
            }
        }
        return nil
    }
    
    func buildWord(_ json: JSON) {
        print("Building word....")
        wordToPresent = Word(json: json)
    }
}

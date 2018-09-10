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
        networker = Networker.shared
        networker?.networkerDelegate = self
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
    
    override func loadView() {
        super.loadView()
        
        //view.backgroundColor = UIColor.white
    }
    
    @objc func solveTapped() {
        // This will present an alert controller with a text field for the user to submit their
        // spelling attempt. If they're correct, it will play a noise and load a "Tap to Continue" screen
        // for when the user is ready.
        
        if let num = numberOfWordsToPresent {
            print("solve works - \(num)")
        }
    }
    
    @objc func skipTapped() {
        // The user can choose to skip the current word without it counting against their selected goal.
        print("Skip works")
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        loadWord()
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

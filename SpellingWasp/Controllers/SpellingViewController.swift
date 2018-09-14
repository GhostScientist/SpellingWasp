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
    
    // MARK: - Instance Variables
    var numCorrect = 0
    
    // MARK: - IB Connections
    @IBOutlet weak var secretWord: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var repeatOutlet: UIButton!
    @IBOutlet weak var exampleOutlet: UIButton!
    
    // MARK: - Observed properties
    internal var numberOfWordsToPresent: Int? {
        didSet {
            chosenNum = true
        }
    }
    
    var wordToPresent: Word? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                if let word = self.wordToPresent {
                    self.secretWord.text = word.convertToUnderscores()
                    self.groupLabel.text = word.classification
                    if word.originOfWord == "" {
                        self.originLabel.text = "There's not enough information about the origin of this word."
                    } else {
                        self.originLabel.text = word.originOfWord
                    }
                    self.speak("Your word is...\(word.word)")
                }
            }
        }
    }
    
    // MARK: - Instance variables
    
    var count = 0
    internal var chosenNum = false
    var player: AVPlayer?
    var networker: Networker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networker = Networker.shared
        networker?.networkerDelegate = self
        loadUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if chosenNum == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [unowned self] in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerView") as! PickerViewController
                vc.pickerDelegate = self
                self.present(vc, animated: true)
            }
        } 
    }
    
    func loadUI() {
        title = "Loading..."
        repeatOutlet.layer.cornerRadius = repeatOutlet.frame.height / 2
        exampleOutlet.layer.cornerRadius = exampleOutlet.frame.height / 2
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Solve", style: .plain, target: self, action: #selector(solveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))
        originLabel.adjustsFontSizeToFitWidth = true
        secretWord.adjustsFontSizeToFitWidth = true
    }
    
    override func loadView() {
        super.loadView()
    }
    
    // MARK: - Methods
    
    func speak(_ word: String) {
        let utter = AVSpeechUtterance(string: word)
        utter.rate = 0.4
        let synth = AVSpeechSynthesizer()
        synth.speak(utter)
    }
    
    @objc func solveTapped() {
        // This will present an alert controller with a text field for the user to submit their
        // spelling attempt. If they're correct, it will play a noise and load a "Tap to Continue" screen
        // for when the user is ready.
        
        let ac = UIAlertController(title: "Solve!", message: "Submit your spelling attempt.", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned self] (action) in
            if ac.textFields![0].text!.lowercased() == self.wordToPresent!.word.lowercased() { // If the word the user entered is correct
                self.numCorrect += 1
                self.wordToPresent?.correctAnswer()
                self.loadWord(skipped: false)
            } else {
                DispatchQueue.main.async {
                    self.wordToPresent?.wrongAnswer()
                    self.loadWord(skipped: false)
                }
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
            self.loadWord(skipped: true)
        }))
        present(ac, animated: true)
    }

    
    func loadWord(skipped: Bool) {
        print("Loading word...")
        
        if count == numberOfWordsToPresent! {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Results") as! ResultsViewController
            if let numSelected = numberOfWordsToPresent {
                vc.totalNum = numSelected
                vc.numCorrect = numCorrect
            }
            present(vc, animated: true)
        }
        
        if let wordToLoad = generateWord() {
            print("Loading word: \(wordToLoad)")
            networker.grabWordInfo(word: wordToLoad, skipped: skipped)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        // Will play the audio file downloaded from the dictionary.
        if let word = wordToPresent {
            speak("Your word is \(word.word)")
        }
    }
    
    @IBAction func exampleTapped(_ sender: UIButton) {
        if let word = wordToPresent {
            speak(word.examplesOfUsage)
        }
    }
    
    // Delegate method

    func didTap(num: Int) {
        numberOfWordsToPresent = num
        title = "\(count) / \(numberOfWordsToPresent!)"
        loadWord(skipped: false)
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
    
    func buildWord(_ json: JSON, skipped: Bool) {
        if !skipped {
            count += 1
        }
        DispatchQueue.main.async { [unowned self] in
            self.title = "\(self.count) / \(self.numberOfWordsToPresent!)"
            self.wordToPresent = Word(json: json)
        }
    }
}

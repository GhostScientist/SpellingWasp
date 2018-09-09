//
//  SpellingViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/5/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit

class SpellingViewController: UIViewController, PickerDelegate {
    
    internal var numberOfWordsToPresent: Int? {
        didSet {
            chosenNum = true
        }
    }
    
    internal var chosenNum = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpellingWasp"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Solve", style: .plain, target: self, action: #selector(solveTapped))
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        //view.backgroundColor = UIColor.white
    }
    
    @objc func solveTapped() {
        if let num = numberOfWordsToPresent {
            print("solve works - \(num)")
        }
    }
    
    @objc func skipTapped() {
        print("Skip works")
    }
    
    // MARK: - IB Actions
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        if let num = numberOfWordsToPresent {
            print(num)
        }
    }
    
    @IBAction func exampleTapped(_ sender: UIButton) {
    }

    func didTap(num: Int) {
        numberOfWordsToPresent = num
        print(chosenNum)
        print(numberOfWordsToPresent)
    }
}

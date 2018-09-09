//
//  SpellingViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/5/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit

class SpellingViewController: UIViewController {
    
    var numberOfWordsToPresent: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpellingWasp"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Solve", style: .plain, target: self, action: #selector(solveTapped))
        
        // Do any additional setup after loading the view.
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
    
    
}

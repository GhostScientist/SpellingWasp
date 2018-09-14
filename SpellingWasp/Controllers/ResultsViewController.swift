//
//  ResultsViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/12/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    // Instance Variables
    var totalNum : Int!
    var numCorrect: Int!
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var numberCorrect: UILabel!
    @IBOutlet weak var numberTotal: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let numRight = numCorrect, let numTotal = totalNum {
            numberCorrect.text = "\(numRight) Right"
            numberTotal.text = "\(numTotal) Total"
        }
    }
    
    // MARK: - IB Actions
    
    
    
}

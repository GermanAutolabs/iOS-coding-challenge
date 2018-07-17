//
//  SpeechRecognizerViewController.swift
//  iOS coding challenge for German Autolabs
//
//  Created by Antonio De Mingo Navarro on 17/07/2018.
//  Copyright © 2018 Antonio De Mingo Navarro. All rights reserved.
//

import UIKit

class SpeechRecognizerViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Action Methods
    @IBAction func recordingButtonTapped(_ sender: UIButton) {
        
    }
    

}

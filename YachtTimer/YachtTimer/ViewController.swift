//
//  ViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var closeOverlayLeftButton: UIButton!
    
    @IBOutlet weak var upArrowButton: UIButton!
    @IBOutlet weak var downArrowButton: UIButton!
    
    var counterReference: Int = 300
    var timer: Timer? = nil {
        didSet {
            if timer == nil {
                startButton.setBackgroundImage(#imageLiteral(resourceName: "startButton"), for: .normal)
                startButton.setTitle("Start", for: .normal)
                syncButton.setTitle("Reset", for: .normal)
                UIApplication.shared.isIdleTimerDisabled = true
            } else {
                startButton.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
                startButton.setTitle("Stop", for: .normal)
                syncButton.setTitle("Sync", for: .normal)
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    var collection: PhoneLabelCollection? = nil
    
    let alert = TextToSpeech()
    
    let green = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    let yellow = UIColor(red: 255/255, green: 251/255, blue: 80/255, alpha: 1)
    let red = UIColor(red: 223/255, green: 114/255, blue: 109/255, alpha: 1)
    var currentLabelColor: UIColor!
    
    var counter: Int = 65 {
        didSet {
            if counter < 0 {
                counter = 0
                return
            } else if counter == 0, let timer = timer {
                counterFinished(timer)
            }
            if timer != nil {
                manageSpeech(counter)
            }
            updateDisplay(counter, for: collection)
        }
    }
    
    var endDate: Date? = nil {
        didSet {
            if endDate != nil {
                upArrowButton.isHidden = true
                downArrowButton.isHidden = true
            } else {
                upArrowButton.isHidden = false
                downArrowButton.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        counter = counterReference
        setLabelColor(green)
        prepareOverlaysAndButtons()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        if let timer = timer {
            stopTimer(timer)
        } else {
            startTimer()
        }
        
        
        
    }
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        syncResetTimer(timer, resetCompletionHandler: resetLabels)
    }
    @IBAction func swipeUp(_ sender: Any) {
        addMinute(failure: nil, completion: nil)
    }
    @IBAction func swipeDown(_ sender: Any) {
        subtractMinute(failure: nil, completion: nil)
    }
    @IBAction func upArrowPressed(_ sender: Any) {
        addMinute(failure: nil, completion: nil)
    }
    @IBAction func downArrowPressed(_ sender: Any) {
        subtractMinute(failure: nil, completion: nil)
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        overlayView.isHidden = false
        helpButton.isHidden = true
    }
    
    @IBAction func closeOverlayLeftButtonPressed(_ sender: Any) {
        overlayView.isHidden = true
        helpButton.isHidden = false
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        
    }
    
    
}

extension ViewController: TimerManager {
    //MARK: Timer functions
    
    
    func counterFinished(_ timer: Timer) {
        let date = endDate
        stopTimer(timer)
        counter = counterReference
        if let stopWatchVC = self.tabBarController?.viewControllers?[1] as? StopwatchViewController {
            stopWatchVC.startDate = date
            stopWatchVC.lapDate = date
            self.tabBarController?.selectedViewController = stopWatchVC
        }
        
    }
}

extension ViewController {
    //MARK: Label handling functions
    
    func updateDisplay(_ time: Int, for collection: LabelCollection?) {
        let minutes = time / 60
        minuteLabel.text = String(format: "%02i", minutes)
        let seconds = time % 60
        secondLabel.text = String(format: "%02i", seconds)
        manageLabels(time)
    }
    
    func manageLabels(_ time: Int) {
        switch time{
        case 60 ... 119:
            setLabelColor(yellow)
            resetLabels()
            
        case 1 ... 59:
            enlargeSeconds()
            setLabelColor(red)
            
        default:
            setLabelColor(green)
            resetLabels()
            
        }
    }
    
    func resetLabels() {
        if minuteLabel.isHidden {
            minuteLabel.isHidden = false
        }
        
        if separatorLabel.isHidden {
            separatorLabel.isHidden = false
        }
        secondLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func enlargeSeconds() {
        
        minuteLabel.isHidden = true
        separatorLabel.isHidden = true
        secondLabel.transform = CGAffineTransform(scaleX: 1.66, y: 1.66)
    }
    
    
    
    func setLabelColor(_ color: UIColor) {
        if currentLabelColor != color {
            minuteLabel.textColor = color
            separatorLabel.textColor = color
            secondLabel.textColor = color
            currentLabelColor = color
        }
    }
    
}

extension ViewController {
    //MARK: Speech handling
    
    func manageSpeech(_ time: Int) {
        
        if counter % 60 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 120 && counter % 30 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 60 && counter % 15 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 30 && counter % 5 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 15 {
            alert.sayOutLoud(counter)
        } else if counter == 0 {
            alert.sayOutLoud("Start")
        }
        
    }
}

extension ViewController {
    //MARK: Overlay handling
    
    func prepareControlButtons() {
        
    }
    
    func prepareOverlaysAndButtons() {
        upArrowButton.tintColor = green
        downArrowButton.tintColor = green
        overlayView.backgroundColor = UIColor(white: 0.25, alpha: 0.35)
        overlayView.isHidden = true
        let helpImage = #imageLiteral(resourceName: "QuestionMark").withRenderingMode(.alwaysTemplate)
        helpButton.setImage(helpImage, for: .normal)
        let settingsImage = #imageLiteral(resourceName: "Cogwheel").withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(settingsImage, for: .normal)
        let closeOverlayImage = #imageLiteral(resourceName: "XMark").withRenderingMode(.alwaysTemplate)
        closeOverlayLeftButton.setImage(closeOverlayImage, for: .normal)
    }
}

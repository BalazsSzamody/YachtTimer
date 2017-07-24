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
    
    var counterReference: Int = 300
    var timer = Timer()
    
    var green = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    var yellow = UIColor(red: 255/255, green: 251/255, blue: 80/255, alpha: 1)
    var red = UIColor(red: 223/255, green: 114/255, blue: 109/255, alpha: 1)
    var currentLabelColor: UIColor!
    
    var counter: Int = 65 {
        didSet {
            switch counter{
            case 60 ... 119:
                setLabelColor(yellow)
                if oldValue < 60 {
                    resetLabels()
                }
            case 1 ... 59:
                    enlargeSeconds()
                    setLabelColor(red)
            case 0:
                if isTimerRunning {
                    timer.invalidate()
                    isTimerRunning = false
                    counterFinished()
                }
                resetLabels()
            
            default:
                if counter < 0 {
                    counter = 0
                } else {
                    setLabelColor(green)
                    if oldValue < 60 {
                        resetLabels()
                    }
                }
            }
            print(counter)
            updateDisplay(counter)
        }
        
    }
    
    var isTimerRunning = false {
        didSet{
            if !isTimerRunning {
                startButton.setBackgroundImage(#imageLiteral(resourceName: "startButton"), for: .normal)
                startButton.setTitle("Start", for: .normal)
                syncButton.setTitle("Reset", for: .normal)
            } else {
                startButton.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
                startButton.setTitle("Stop", for: .normal)
                syncButton.setTitle("Sync", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        counter = 300
        updateDisplay(counter)
        setLabelColor(green)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        switch isTimerRunning {
        case true:
            timer.invalidate()
            isTimerRunning = false
            
        case false:
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in 
                self.counter -= 1
            }
            isTimerRunning = true
            
        }
    }
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        switch isTimerRunning{
        case true:
            timer.invalidate()
            if counter % 60 > 30 {
                counter += 60 - ( counter % 60 )
            } else {
                counter -= counter % 60
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                self.counter -= 1
            }
        case false:
            counter = counterReference
            resetLabels()
        }
    }
    @IBAction func swipeUp(_ sender: Any) {
        if !isTimerRunning {
            counter += 60
            counterReference = counter
        }
    }
    @IBAction func swipeDown(_ sender: Any) {
        if !isTimerRunning {
            counter -= 60
            counterReference = counter
        }
    }
    
    
    func updateDisplay(_ time: Int) {
        let minutes = time / 60
        minuteLabel.text = String(format: "%02i", minutes)
        let seconds = time % 60
        secondLabel.text = String(format: "%02i", seconds)
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
    
    func counterFinished() {
        counter = counterReference
        if let stopWatchVC = self.tabBarController?.viewControllers?[1] as? StopwatchViewController {
            stopWatchVC.startStopWatch()
            self.tabBarController?.selectedViewController = stopWatchVC
        }
        
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


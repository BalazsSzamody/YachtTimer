//
//  StopwatchViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var fractionSecondsLabel: UILabel!
    @IBOutlet weak var hoursSeparator: UILabel!
    @IBOutlet weak var minutesSeparator: UILabel!
    @IBOutlet weak var secondsSeparator: UILabel!
    @IBOutlet weak var displayStackView: UIStackView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    var labels: [UILabel]!
    
    var isStopWatchRunning = false {
        didSet {
            switch isStopWatchRunning {
            case true:
                // necessary for not getting optional crash after coming from timer view without opening Stopwatch screen first
                guard let startButton = startButton else { return }
                guard let lapButton = lapButton else { return }
                
                startButton.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
                startButton.setTitle("Stop", for: .normal)
                lapButton.setTitle("Lap", for: .normal)
            case false:
                startButton.setBackgroundImage(#imageLiteral(resourceName: "startButton"), for: .normal)
                startButton.setTitle("Start", for: .normal)
                lapButton.setTitle("Reset", for: .normal)
            }
        }
    }
    
    var stopWatch = Timer()
    var counter: Int = 0 {
        didSet {
            updateDisplay(counter)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // necessary to show correct buttons if coming from timer view
        if isStopWatchRunning {
            isStopWatchRunning = false
            isStopWatchRunning = true
        }
        
        labels = [hoursLabel, hoursSeparator, minutesLabel, minutesSeparator, secondsLabel, secondsSeparator, fractionSecondsLabel]
        
        updateDisplay(counter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        switch isStopWatchRunning {
        case false:
            startStopWatch()
            
        case true:
            stopStopWatch()
            
        }
        
    }

    @IBAction func lapButtonTapped(_ sender: UIButton) {
        switch isStopWatchRunning {
        case false:
            counter = 0
            
            
        case true:
            break
        }
        
    }
    
    func startStopWatch() {
        stopWatch = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
            self.counter += 1
        }
        isStopWatchRunning = true
    }
    
    func stopStopWatch() {
        stopWatch.invalidate()
        isStopWatchRunning = false
    }
    
    
    func updateDisplay(_ time: Int) {
        
        let hours = time / 360000
        if hours == 0 {
            if !hoursLabel.isHidden {
                hoursLabel.isHidden = true
                hoursSeparator.isHidden = true
            }
        } else {
            if hoursLabel.isHidden {
                hoursLabel.isHidden = false
                hoursSeparator.isHidden = false
            }
            hoursLabel.text = String(hours)
        }
        
        let minutes = ( time % 360000 ) / 6000
        if hours == 0 && minutes == 0 {
            if !minutesLabel.isHidden {
                minutesLabel.isHidden = true
                minutesSeparator.isHidden = true
                
            }
        } else {
            if minutesLabel.isHidden {
                minutesLabel.isHidden = false
                minutesSeparator.isHidden = false
            }
            minutesLabel.text = String(format: "%02i", minutes)
        }
        
        let scale = determineScale()
        setLabelSize(scale)
        
        
        let seconds = ( time % 6000 ) / 100
        secondsLabel.text = String(format: "%02i", seconds)
        let fractionSeconds = time % 100
        fractionSecondsLabel.text = String(format: "%02i", fractionSeconds)
    }
    
    
    func determineScale() -> CGFloat {
        //determine scale based on how many labels are hidden
        var scaleCounter = 0
        for label in labels {
            if label.isHidden {
                scaleCounter += 1
            }
        }
        switch scaleCounter {
        case 1 ... 2:
            return 1.33
        case 3 ... 4:
            return 1.66
        default:
            return 1
        }
    }
    
    func setLabelSize(_ scale: CGFloat) {
        //set the size of the visible Labels
        displayStackView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

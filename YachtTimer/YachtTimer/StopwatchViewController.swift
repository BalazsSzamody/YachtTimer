//
//  StopwatchViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var fractionSecondsLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    var isStopWatchRunning = false
    
    var stopWatch = Timer()
    var decimalSeconds: Int = 0 {
        willSet {
            if newValue == 100 {
                seconds += 1
            }
        }
        didSet{
            if decimalSeconds == 100 {
                decimalSeconds = 0
                
            }
            fractionSecondsLabel.text = displayTime(decimalSeconds)
        }
    }
    var seconds: Int = 0 {
        willSet{
            if newValue == 60 {
                minutes += 1
            }
        }
        didSet {
            if seconds == 60 {
                seconds = 0
            }
            secondsLabel.text = displayTime(seconds)
        }
    }
    var minutes: Int = 0 {
        didSet {
            minutesLabel.text = displayTime(minutes)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lapButton.setTitle("Reset", for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        switch isStopWatchRunning {
        case false:
            startStopWatch()
            startButton.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            startButton.setTitle("Stop", for: .normal)
            lapButton.setTitle("Lap", for: .normal)
        case true:
            stopStopWatch()
            startButton.setBackgroundImage(#imageLiteral(resourceName: "startButton"), for: .normal)
            startButton.setTitle("Start", for: .normal)
            lapButton.setTitle("Reset", for: .normal)
        }
        
    }

    @IBAction func lapButtonTapped(_ sender: UIButton) {
        switch isStopWatchRunning {
        case false:
            decimalSeconds = 0
            seconds = 0
            minutes = 0
            
        case true:
            break
        }
        
    }
    
    func startStopWatch() {
        stopWatch = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(StopwatchViewController.updateStopWatch)), userInfo: nil, repeats: true)
        isStopWatchRunning = true
    }
    
    func stopStopWatch() {
        stopWatch.invalidate()
        isStopWatchRunning = false
    }
    
    func updateStopWatch() {
        decimalSeconds += 1
    }
    
    func displayTime(_ time: Int) -> String {
        return String(format: "%02i", time)
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

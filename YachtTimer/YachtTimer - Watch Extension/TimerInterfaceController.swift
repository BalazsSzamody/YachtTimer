//
//  InterfaceController.swift
//  YachtTimer - Watch Extension
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 03..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import WatchKit
import Foundation

enum ScreenSize{
    case small
    case big
}


class TimerInterfaceController: WKInterfaceController {
    @IBOutlet var minutesLabel: WKInterfaceLabel!
    @IBOutlet var separatorLabel: WKInterfaceLabel!
    @IBOutlet var secondsLabel: WKInterfaceLabel!
    @IBOutlet var timerGroup: WKInterfaceGroup!

    @IBOutlet var startStopButtonImage: WKInterfaceImage!
    @IBOutlet var syncResetButtonImage: WKInterfaceImage!
    
    @IBOutlet var swipeUpGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet var swipeDownGestureRecognizer: WKSwipeGestureRecognizer!
    
    @IBOutlet var upArrowImage: WKInterfaceImage!
    @IBOutlet var downArrowImage: WKInterfaceImage!
    
    var currentScreenSize: ScreenSize!
    
    var counterReference: Int = 300
    
    var timer: Timer? = nil {
        didSet {
            if timer == nil {
                //Handle Timer not running stuff
                startStopButtonImage.setTintColor(green)
                upArrowImage.setHidden(false)
                downArrowImage.setHidden(false)
                
            } else {
                //Handle Timer is running stuff
                startStopButtonImage.setTintColor(red)
                upArrowImage.setHidden(true)
                downArrowImage.setHidden(true)
            }
        }
    }
    
    let alert = TextToSpeech()
    
    // Used Colors
    let green = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    let yellow = UIColor(red: 255/255, green: 251/255, blue: 80/255, alpha: 1)
    let red = UIColor(red: 223/255, green: 114/255, blue: 109/255, alpha: 1)
    var currentLabelColor: UIColor!
    
    var counter: Int = 300 {
        didSet {
            if counter < 0 {
                counter = 0
                return
            }
            
            if timer != nil {
                manageSpeech(counter)
            }
            manageLabels(counter)
            updateDisplay(counter)
        }
    }
    
    var context: Any? = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let screenBounds = WKInterfaceDevice.current().screenBounds
        if screenBounds.width > 140 {
            currentScreenSize = .big
        } else {
            currentScreenSize = .small
        }
        counter = counterReference
        self.context = context
        startStopButtonImage.setTintColor(green)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if context == nil {
         
            WKInterfaceController.reloadRootControllers(withNames: ["TimerInterface", "StopwatchInterface"], contexts: [[], [true, true]])
        }
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func startStopPressed() {
        if let timer = timer {
            stopTimer(timer)
        } else {
            startTimer()
            alert.sayOutLoud(counter)
        }
    }
    
    @IBAction func syncResetPressed() {
        if let timer = timer {
            stopTimer(timer)
            if counter % 60 > 30 {
                counter += 60 - ( counter % 60 )
            } else {
                counter -= counter % 60
            }
            startTimer()
        } else {
            counter = counterReference
        }
    }
    
    @IBAction func swipe(_ sender: Any) {
        
        guard let sender = sender as? WKSwipeGestureRecognizer else { return }
        
        if sender == swipeUpGestureRecognizer {
            addMinute()
        } else if sender == swipeDownGestureRecognizer {
            subtractMinute()
        }
    }
    
    @IBAction func upArrowPressed() {
        addMinute()
    }
    
    @IBAction func downArrowPressed() {
        subtractMinute()
    }
   
    

}

extension TimerInterfaceController {
    //MARK: Timer functions
    func startTimer() {
        timer = Timer(timeInterval: 1, repeats: true) {_ in
            self.counter -= 1
        }
        
        guard let timer = timer else { return }
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    func stopTimer(_ timer: Timer) {
        
        timer.invalidate()
        self.timer = nil
    }
    
    func counterFinished() {
        counter = counterReference
        //presentController(withName: "StopwatchInterface", context: ["segue": "pagebased", "data": "Start"])
        //pushController(withName: "StopwatchInterface", context: "StartStopWatch")
        
        WKInterfaceController.reloadRootControllers(withNames: ["TimerInterface", "StopwatchInterface"], contexts: [Context(false), Context(true)])
    }
    
    func addMinute() {
        guard timer == nil else { return }
        guard counter < 3600 else { return }
        if counter % 60 != 0 {
            counter += 60 - ( counter % 60 )
        } else {
            counter += 60
        }
        
    }
    
    func subtractMinute() {
        guard timer == nil else { return }
        guard counter > 60 else { return }
        if counter % 60 != 0 {
            counter -=  counter % 60
        } else {
            counter -= 60
        }
    }
    
}

extension TimerInterfaceController {
    //MARK: Label handling
    func updateDisplay(_ counter: Int) {
        let time = calculateTime(counter)
        
        if let minutesText = time.minutesText {
            minutesLabel.setHidden(false)
            separatorLabel.setHidden(false)
            minutesLabel.setText(minutesText)
            secondsLabel.setText(time.secondsText)
        } else {
            minutesLabel.setHidden(true)
            separatorLabel.setHidden(true)
            if currentScreenSize == .big {
                secondsLabel.setAttributedText(NSAttributedString(string: time.secondsText, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 95, weight: UIFontWeightRegular)]))
            } else {
                secondsLabel.setAttributedText(NSAttributedString(string: time.secondsText, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 77, weight: UIFontWeightRegular)]))
            }
            
        }
        
        
    }
    
    func manageLabels(_ time: Int) {
        switch time{
        case 60 ... 119:
            setLabelColor(yellow)
            resetSeconds()
            
        case 1 ... 59:
            enlargeSeconds()
            setLabelColor(red)
            
        case 0:
            if let timer = timer {
                stopTimer(timer)
                counterFinished()
            }
            resetSeconds()
            
        default:
            setLabelColor(green)
            resetSeconds()
            
        }
    }
    
    func resetSeconds() {
        if currentScreenSize == .big {
            secondsLabel.setWidth(71)
            secondsLabel.setHeight(55)
        } else {
            secondsLabel.setWidth(62)
            secondsLabel.setHeight(45)
        }
        
    }
    
    func enlargeSeconds() {
        if currentScreenSize == .big {
            secondsLabel.setWidth(106)
            secondsLabel.setHeight(87)
        } else {
            secondsLabel.setWidth(100)
            secondsLabel.setHeight(65)
        }
    }
    
    func calculateTime(_ counter: Int) -> (minutesText: String?, secondsText: String) {
        let minutes = counter / 60
        let seconds = counter % 60
        
        return (minutes > 0 ? String(format: "%02i", minutes) : nil, String(format: "%02i", seconds))
    }
    
    func setLabelColor(_ color: UIColor) {
        if currentLabelColor != color {
            minutesLabel.setTextColor(color)
            separatorLabel.setTextColor(color)
            secondsLabel.setTextColor(color)
            currentLabelColor = color
        }
    }
}

extension TimerInterfaceController {
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



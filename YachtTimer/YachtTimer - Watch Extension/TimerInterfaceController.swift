//
//  InterfaceController.swift
//  YachtTimer - Watch Extension
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 03..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import WatchKit
import Foundation



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
    
    var collection: WatchLabelCollection? = nil
    
    var currentScreenSize: ScreenSize? = nil
    
    var counterReference: Int = 300
    
    let alert = TextToSpeech()
    
    var context: Any? = nil
    
    // Used Colors
    let green = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    let yellow = UIColor(red: 255/255, green: 251/255, blue: 80/255, alpha: 1)
    let red = UIColor(red: 223/255, green: 114/255, blue: 109/255, alpha: 1)
    let offWhite = UIColor(red: 197/255, green: 226/255, blue: 196/255, alpha: 1)
    var currentLabelColor: UIColor!
    
    //Button image definitions in extension
    var startIcon: ButtonImage!
    var pauseIcon: ButtonImage!
    var resetIcon: ButtonImage!
    var syncIcon: ButtonImage!
    
    var crownRotation: Double = 0 {
        didSet {
            if crownRotation > 0.5 {
                crownRotation = 0
                addMinute()
            } else if crownRotation < -0.5 {
                crownRotation = 0
                subtractMinute()
            }
        }
    }
    
    var timer: Timer? = nil {
        didSet {
            if timer == nil {
                //Handle Timer not running stuff
                buttonsForStopped()
                
            } else {
                //Handle Timer is running stuff
                buttonsForRunning()
                
            }
        }
    }
    
    var counter: Int = 300 {
        didSet {
            if counter < 0 {
                counter = 0
                return
            } else if counter == 0, let timer = timer {
                stopTimer(timer)
                counterFinished()
            }
            
            if timer != nil {
                manageSpeech(counter)
            }
            manageLabelColors(counter)
            updateDisplay(counter, for: collection)
        }
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let screenBounds = WKInterfaceDevice.current().screenBounds
        if screenBounds.width > 140 {
            currentScreenSize = .big
        } else {
            currentScreenSize = .small
        }
        collection = WatchLabelCollection(itemMultiplier: 1, labels: [minutesLabel, separatorLabel, secondsLabel])
        counter = counterReference
        self.context = context
        prepareButtonImages()
        buttonsForStopped()
        crownSequencer.delegate = self
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        crownSequencer.resignFocus()
    }
    
    @IBAction func startStopPressed() {
        playHaptic(.start)
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
        
        
        WKInterfaceController.reloadRootControllers(withNames: ["TimerInterface", "StopwatchInterface"], contexts: [Context(false), Context(true)])
    }
    
    func addMinute() {
        
        guard timer == nil else { return }
        guard counter < 3600 else {
            playHaptic(.failure)
            return
        }
        
        playHaptic(.directionUp)
        if counter % 60 != 0 {
            counter += 60 - ( counter % 60 )
        } else {
            counter += 60
        }
        
    }
    
    func subtractMinute() {
        
        guard timer == nil else { return }
        guard counter > 60 else {
            playHaptic(.failure)
            return
        }
        
        playHaptic(.directionDown)
        if counter % 60 != 0 {
            counter -=  counter % 60
        } else {
            counter -= 60
        }
    }
    
}

extension TimerInterfaceController: WatchTimerTimeDisplay {
    //MARK: Label handling
    // updateDisplay is default in WatchTimerTimeDisplay protocol
    
    func manageLabelColors(_ time: Int) {
        switch time{
        case 60 ... 119:
            setLabelColor(yellow)
            
        case 1 ... 59:
            setLabelColor(red)
       
            
        default:
            setLabelColor(green)
            
        }
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
    // Button handling
    
    func prepareButtonImages() {
        startIcon = ButtonImage(image: #imageLiteral(resourceName: "startIcon"), color: green)
        pauseIcon = ButtonImage(image: #imageLiteral(resourceName: "pauseIcon"), color: red)
        resetIcon = ButtonImage(image: #imageLiteral(resourceName: "closeIcon"), color: red)
        syncIcon = ButtonImage(image: #imageLiteral(resourceName: "syncIcon"), color: offWhite)
    }
    
    func buttonsForStopped() {
        startStopButtonImage.setImageAndColor(startIcon)
        syncResetButtonImage.setImageAndColor(resetIcon)
        upArrowImage.setHidden(false)
        downArrowImage.setHidden(false)
    }
    
    func buttonsForRunning() {
        startStopButtonImage.setImageAndColor(pauseIcon)
        syncResetButtonImage.setImageAndColor(syncIcon)
        upArrowImage.setHidden(true)
        downArrowImage.setHidden(true)
    }
}

extension TimerInterfaceController {
    //MARK: Alert handling
    
    func manageSpeech(_ time: Int) {
        
        if counter % 60 == 0 {
            alert.sayOutLoud(counter)
            playHaptic(.notification)
        } else if counter < 120 && counter % 30 == 0 {
            alert.sayOutLoud(counter)
            playHaptic(.notification)
        } else if counter < 60 && counter % 15 == 0 {
            alert.sayOutLoud(counter)
            playHaptic(.notification)
        } else if counter < 30 && counter % 5 == 0 {
            alert.sayOutLoud(counter)
            playHaptic(.notification)
        } else if counter < 15 {
            alert.sayOutLoud(counter)
            playHaptic(.notification)
        } else if counter == 0 {
            alert.sayOutLoud("Start")
            playHaptic(.notification)
        }
        
    }
    
    func playHaptic(_ type: WKHapticType) {
        WKInterfaceDevice.current().play(type)
    }
}


extension TimerInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        crownRotation += rotationalDelta
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        crownRotation = 0
    }
}


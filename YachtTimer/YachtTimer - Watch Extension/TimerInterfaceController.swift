//
//  InterfaceController.swift
//  YachtTimer - Watch Extension
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 03..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

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
    
    var currentScreenSize: WatchScreenSize? = nil
    
    var counterReference: Int = 300
    
    let alert = TextToSpeech()
    
    var context: Any? = nil
    
    // Background Haptic requiremnts
    
    let healthStore = HKHealthStore()
    
    var workoutSession: HKWorkoutSession?
    
    // Used Colors
    let green = InterfaceColor.brightGreen
    let yellow = InterfaceColor.brightYellow
    let red = InterfaceColor.brightRed
    let white = InterfaceColor.white
    let blue = InterfaceColor.lightBlue
    
    //Button image definitions in extension
    var startIcon: ButtonImage!
    var pauseIcon: ButtonImage!
    var resetIcon: ButtonImage!
    var syncIcon: ButtonImage!
    
    var crownRotation: Double = 0 {
        didSet {
            if crownRotation > 0.5 {
                crownRotation = 0
                addMinute(failure: failHaptic, completion: completeHaptic)
            } else if crownRotation < -0.5 {
                crownRotation = 0
                subtractMinute(failure: failHaptic, completion: completeHaptic)
            }
        }
    }
    
    var timer: Timer? = nil {
        didSet {
            if timer == nil {
                //Handle Timer not running stuff
                switchToStartButtons()
                stopWorkout()
            } else {
                //Handle Timer is running stuff
                switchToRunningButtons()
                startWorkout()
            }
        }
    }
    
    var counter: Int = 300 {
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
    
    var endDate: Date? = nil
    
    
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
        switchToStartButtons()
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
        }
    }
    
    @IBAction func syncResetPressed() {
            syncResetTimer(timer, resetCompletionHandler: nil)
    }
    
    @IBAction func swipe(_ sender: Any) {
        
        guard let sender = sender as? WKSwipeGestureRecognizer else { return }
        
        if sender == swipeUpGestureRecognizer {
            addMinute(failure: failHaptic, completion: completeHaptic)
        } else if sender == swipeDownGestureRecognizer {
            subtractMinute(failure: failHaptic, completion: completeHaptic)
        }
    }
    
    @IBAction func upArrowPressed() {
        addMinute(failure: failHaptic, completion: completeHaptic)
    }
    
    @IBAction func downArrowPressed() {
        subtractMinute(failure: failHaptic, completion: completeHaptic)
    }
   
    

}

extension TimerInterfaceController: TimerManager {
    //MARK: Timer functions
    
 
    func counterFinished(_ timer: Timer) {
        let date: Date
        if let endDate = endDate {
            date = endDate
        } else {
            date = Date()
        }
        stopTimer(timer)
        counter = counterReference
        
        WKInterfaceController.reloadRootControllers(withNames: ["TimerInterface", "StopwatchInterface"], contexts: [Context(false), Context(date)])
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
            setLabelColor(white)
            
        }
    }
    
    func setLabelColor(_ color: UIColor) {
            minutesLabel.setTextColor(color)
            separatorLabel.setTextColor(color)
            secondsLabel.setTextColor(color)
    }
}

extension TimerInterfaceController {
    // Button handling
    
    func prepareButtonImages() {
        startIcon = ButtonImage(image: #imageLiteral(resourceName: "startIcon"), color: green)
        pauseIcon = ButtonImage(image: #imageLiteral(resourceName: "pauseIcon"), color: red)
        resetIcon = ButtonImage(image: #imageLiteral(resourceName: "closeIcon"), color: red)
        syncIcon = ButtonImage(image: #imageLiteral(resourceName: "syncIcon"), color: green)
    }
    
    func switchToStartButtons() {
        startStopButtonImage.setImageAndColor(startIcon)
        syncResetButtonImage.setImageAndColor(resetIcon)
        upArrowImage.setHidden(false)
        downArrowImage.setHidden(false)
    }
    
    func switchToRunningButtons() {
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
    
    func failHaptic() {
        playHaptic(.failure)
    }
    
    func completeHaptic() {
        playHaptic(.directionUp)
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

extension TimerInterfaceController {
    func startWorkout() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        
        do {
            workoutSession = try HKWorkoutSession(configuration: workoutConfiguration)
            print("WorkoutStarted")
            workoutSession?.delegate = self
            healthStore.start(workoutSession!)
        } catch {
            print(error)
        }
    }
    
    func stopWorkout() {
        guard let workoutSession = workoutSession else { return }
        healthStore.end(workoutSession)
        self.workoutSession = nil
    }
}

extension TimerInterfaceController: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
}

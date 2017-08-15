//
//  StopwatchInterfaceController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 03..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import WatchKit
import Foundation


class StopwatchInterfaceController: WKInterfaceController {
    
    @IBOutlet var hoursLabel: WKInterfaceLabel!
    @IBOutlet var hoursSeparator: WKInterfaceLabel!
    @IBOutlet var minutesLabel: WKInterfaceLabel!
    @IBOutlet var minutesSeparator: WKInterfaceLabel!
    @IBOutlet var secondsLabel: WKInterfaceLabel!
    @IBOutlet var secondsSeparator: WKInterfaceLabel!
    @IBOutlet var fractionSecondsLabel: WKInterfaceLabel!
    @IBOutlet var displayGroup: WKInterfaceGroup!
    
    @IBOutlet var smallHoursLabel: WKInterfaceLabel!
    @IBOutlet var smallHoursSeparator: WKInterfaceLabel!
    @IBOutlet var smallMinutesLabel: WKInterfaceLabel!
    @IBOutlet var smallMinutesSeparator: WKInterfaceLabel!
    @IBOutlet var smallSecondsLabel: WKInterfaceLabel!
    @IBOutlet var smallSecondsSeparator: WKInterfaceLabel!
    @IBOutlet var smallFractionSecondsLabel: WKInterfaceLabel!
    @IBOutlet var smallDisplayGroup: WKInterfaceGroup!
    
    @IBOutlet var startStopButtonImage: WKInterfaceImage!
    @IBOutlet var lapResetButtonImage: WKInterfaceImage!
    
    @IBOutlet var lapTable: WKInterfaceTable!
    
    var currentScreenSize: ScreenSize? = nil
    
    var collections: [WatchLabelCollection]? = nil
    
    let green = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    let red = UIColor(red: 223/255, green: 114/255, blue: 109/255, alpha: 1)
    
    var stopWatch: Timer? = nil {
        didSet {
            if stopWatch == nil {
                startStopButtonImage.setTintColor(green)
            } else {
                guard let startStopButtonImage = startStopButtonImage else { return }
                startStopButtonImage.setTintColor(red)
            }
        }
    }
    
    var counter: Int = 0 {
        didSet {
            guard let collections = collections else { return }
            updateDisplay(counter, for: collections[1])
        }
    }
    
    var lapCounter: Int = 0 {
        didSet {
            guard let collections = collections else { return }
            updateDisplay(lapCounter, for: collections[0])
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
        
        checkContext(context)
        setLabels()
        
        
        self.context = context
        startStopButtonImage.setTintColor(green)
        lapTable.setHidden(true)
        smallDisplayGroup.setHidden(true)
        guard let collections = collections else { return }
        for collection in collections {
            updateDisplay(counter, for: collection)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        handleContext(context)
        
    }
    
    func handleContext(_ context: Any?) {
        guard let context = context as? Context else { return }
        print(context)
        if context.shouldStart {
            startStopWatch()
        }
        
        if context.shouldBeCurrentPage {
            self.becomeCurrentPage()
        }
        self.context = nil
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func startStopButtonPressed() {
        if let stopWatch = stopWatch {
            stopStopWatch(stopWatch)
        } else {
            startStopWatch()
        }
    }
    @IBAction func lapResetButtonPressed() {
        if stopWatch != nil {
            
            LapTime.addLap(counter)
            loadTableContent()
            lapCounter = 0
            smallDisplayGroup.setHidden(false)
            lapTable.setHidden(false)
        } else {
            counter = 0
            lapCounter = 0
            lapTable.setHidden(true)
            smallDisplayGroup.setHidden(true)
            LapTime.laps = []
        }
    }
    
    
    
    
    func startStopWatch() {
        stopWatch = Timer(timeInterval: 0.01, repeats: true) {_ in
            self.lapCounter += 1
            self.counter += 1
        }
        guard let stopWatch = stopWatch else { return }
        RunLoop.current.add(stopWatch, forMode: .commonModes)
    }
    
    func stopStopWatch(_ stopWatch: Timer) {
        stopWatch.invalidate()
        self.stopWatch = nil
    }
    
    
    func checkContext(_ context: Any?) {
        guard let context = context as? [String: String] else { return }
        if let dataString = context["data"] {
            if dataString == "Start" {
                startStopWatch()
            }
        }
    }
}

extension StopwatchInterfaceController: WatchStopwatchTimeDisplay {
    func setLabels() {
        guard collections == nil else { return }
        collections = [WatchLabelCollection(itemMultiplier: 1.0, labels: [hoursLabel,
                        hoursSeparator,
                        minutesLabel,
                        minutesSeparator,
                        secondsLabel,
                        secondsSeparator,
                        fractionSecondsLabel]),
                  WatchLabelCollection(itemMultiplier: 0.75, labels: [smallHoursLabel,
                             smallHoursSeparator,
                             smallMinutesLabel,
                             smallMinutesSeparator,
                             smallSecondsLabel,
                             smallSecondsSeparator,
                             smallFractionSecondsLabel])]
    }
}

extension StopwatchInterfaceController {
    //Table control
    func loadTableContent() {
        lapTable.setNumberOfRows(LapTime.laps.count, withRowType: "lapTableRow")
        
        for index in 0 ..< lapTable.numberOfRows {
            guard let controller = lapTable.rowController(at: index) as? LapTableRow else { continue }
            
            controller.currentScreenSize = currentScreenSize
            controller.lapTime = LapTime.laps[index]
        }
    }
}



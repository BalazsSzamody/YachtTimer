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
    
    var currentScreenSize: WatchScreenSize? = nil
    
    var collections: [WatchLabelCollection]? = nil
    
    var startIcon: ButtonImage!
    var pauseIcon: ButtonImage!
    var resetIcon: ButtonImage!
    var lapIcon: ButtonImage!
    
    let green = InterfaceColor.brightGreen
    let red = InterfaceColor.brightRed
    let blue = InterfaceColor.lightBlue
    let white = InterfaceColor.white
    
    var stopWatch: Timer? = nil {
        didSet {
            if stopWatch == nil {
                switchToStartButtons()
            } else {
                switchToRunningButtons()
            }
        }
    }
    
    var startDate: Date? = nil {
        didSet {
            if startDate == nil {
                totalTime = 0
            }
        }
    }
    
    var lapDate: Date? = nil {
        didSet {
            if lapDate == nil {
                lapTime = 0
            }
        }
    }
    
    var totalTime: TimeInterval = 0 {
        didSet{
            guard let collections = collections else { return }
            updateDisplay(totalTime, for: collections[1])
        }
    }
    
    var lapTime: TimeInterval = 0 {
        didSet{
            guard let collections = collections else { return }
            updateDisplay(lapTime, for: collections[0])
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
        setLabels()
        
        
        
        self.context = context
        prepareButtonImages()
        switchToStartButtons()
        startStopButtonImage.setTintColor(green)
        lapTable.setHidden(true)
        smallDisplayGroup.setHidden(true)
        guard let collections = collections else { return }
        for collection in collections {
            updateDisplay(totalTime, for: collection)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        handleContext(context)
        if stopWatch == nil && startDate != nil {
            startStopWatch(startedByUser: false)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        if let stopWatch = stopWatch {
            stopStopWatch(stopWatch, stoppedByUser: false)
        }
    }
    
    func handleContext(_ context: Any?) {
        guard let context = context as? Context else { return }
        if context.shouldStart {
            startDate = context.date
            lapDate = context.date
        }
        
        if context.shouldBeCurrentPage {
            self.becomeCurrentPage()
        }
        self.context = nil
        
    }

    @IBAction func startStopButtonPressed() {
        if let stopWatch = stopWatch {
            stopStopWatch(stopWatch, stoppedByUser: true)
        } else {
            startStopWatch(startedByUser: true)
        }
    }
    @IBAction func lapResetButtonPressed() {
        if stopWatch != nil {
            
            LapTime.addLap(totalTime)
            loadTableContent()
            lapDate = Date()
            smallDisplayGroup.setHidden(false)
            lapTable.setHidden(false)
        } else {
            startDate = nil
            lapDate = nil
            lapTable.setHidden(true)
            smallDisplayGroup.setHidden(true)
            LapTime.laps = []
        }
    }
}

extension StopwatchInterfaceController: StopwatchManager {
    //Stopwatch model
}

extension StopwatchInterfaceController {
    // Button handling
    
    func prepareButtonImages() {
        startIcon = ButtonImage(image: #imageLiteral(resourceName: "startIcon"), color: green)
        pauseIcon = ButtonImage(image: #imageLiteral(resourceName: "pauseIcon"), color: red)
        resetIcon = ButtonImage(image: #imageLiteral(resourceName: "closeIcon"), color: red)
        lapIcon = ButtonImage(image: #imageLiteral(resourceName: "resetIcon"), color: green)
    }
    
    func switchToStartButtons() {
        startStopButtonImage.setImageAndColor(startIcon)
        lapResetButtonImage.setImageAndColor(resetIcon)
    }
    
    func switchToRunningButtons() {
        startStopButtonImage.setImageAndColor(pauseIcon)
        lapResetButtonImage.setImageAndColor(lapIcon)
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



//
//  LapTableRow.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 08. 15..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import WatchKit

class LapTableRow: NSObject, WatchStopwatchTimeDisplay {
    @IBOutlet var lapNumberLabel: WKInterfaceLabel!

    @IBOutlet var lapHoursLabel: WKInterfaceLabel!
    @IBOutlet var lapHoursSeparator: WKInterfaceLabel!
    @IBOutlet var lapMinutesLabel: WKInterfaceLabel!
    @IBOutlet var lapMinutesSeparator: WKInterfaceLabel!
    @IBOutlet var lapSecondsLabel: WKInterfaceLabel!
    @IBOutlet var lapSecondsSeparator: WKInterfaceLabel!
    @IBOutlet var lapFractionSecondsLabel: WKInterfaceLabel!
    @IBOutlet var lapDisplayGroup: WKInterfaceGroup!
    
    @IBOutlet var totalHoursLabel: WKInterfaceLabel!
    @IBOutlet var totalHoursSeparator: WKInterfaceLabel!
    @IBOutlet var totalMinutesLabel: WKInterfaceLabel!
    @IBOutlet var totalMinutesSeparator: WKInterfaceLabel!
    @IBOutlet var totalSecondsLabel: WKInterfaceLabel!
    @IBOutlet var totalSecondsSeparator: WKInterfaceLabel!
    @IBOutlet var totalFractionSecondsLabel: WKInterfaceLabel!
    @IBOutlet var totalDisplayGroup: WKInterfaceGroup!
    
    var collections: [WatchLabelCollection]? = nil
    
    var currentScreenSize: WatchScreenSize? = nil
    
    var lapTime: LapTime? {
        didSet {
            if let lapTime = lapTime {
                if collections == nil {
                    setLabels()
                }
                guard let collections = collections else { return }
                lapNumberLabel.setText("Lap \(lapTime.lapNumber):")
                updateDisplay(lapTime.lapTime, for: collections[0])
                updateDisplay(lapTime.totalTime, for: collections[1])
            }
        }
    }
    
    
    func setLabels() {
        collections = [WatchLabelCollection(itemMultiplier: 0.75, labels: [lapHoursLabel,
                                                                       lapHoursSeparator,
                                                                       lapMinutesLabel,
                                                                       lapMinutesSeparator,
                                                                       lapSecondsLabel,
                                                                       lapSecondsSeparator,
                                                                       lapFractionSecondsLabel]),
                  WatchLabelCollection(itemMultiplier: 0.65,labels:  [totalHoursLabel,
                                                                          totalHoursSeparator,
                                                                          totalMinutesLabel,
                                                                          totalMinutesSeparator,
                                                                          totalSecondsLabel,
                                                                          totalSecondsSeparator,
                                                                          totalFractionSecondsLabel])
                ]
    }
}

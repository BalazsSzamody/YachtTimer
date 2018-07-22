//
//  StopWatchTableViewCell.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 26..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class StopwatchTableViewCell: UITableViewCell {
    
    static let identifier = "StopwatchCell"
    
    @IBOutlet weak var lapHourLabel: UILabel!
    @IBOutlet weak var lapHourSeparator: UILabel!
    @IBOutlet weak var lapMinuteLabel: UILabel!
    @IBOutlet weak var lapMinuteSeparator: UILabel!
    @IBOutlet weak var lapSecondLabel: UILabel!
    @IBOutlet weak var lapFractionSecondLabel: UILabel!
    @IBOutlet weak var lapNameLabel: UILabel!
    
    
    @IBOutlet weak var totalHourLabel: UILabel!
    @IBOutlet weak var totalHourSeparator: UILabel!
    @IBOutlet weak var totalMinuteLabel: UILabel!
    @IBOutlet weak var totalMinuteSeparator: UILabel!
    @IBOutlet weak var totalSecondLabel: UILabel!
    @IBOutlet weak var totalFractionSecondLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    var displayLap: [UILabel]?
    var displayTotal: [UILabel]?
    
    var lapNumber: Int = 0
    
    var totalTime: TimeInterval = 0 {
        didSet {
            updateDisplay(totalTime, at: displayTotal)
            
        }
    }
    
    
    var lapTime: TimeInterval = 0 {
        didSet {
            updateDisplay(lapTime, at: displayLap)
        }
        
    }
    
    override var description: String {
        return "StopWatchTableViewCell: totalTime = \(totalTime), lapTime = \(lapTime)"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        displayLap = [ lapHourLabel, lapHourSeparator, lapMinuteLabel, lapMinuteSeparator, lapSecondLabel, lapFractionSecondLabel, lapNameLabel]
        displayTotal = [ totalHourLabel, totalHourSeparator, totalMinuteLabel, totalMinuteSeparator, totalSecondLabel, totalFractionSecondLabel]
        
        setLabelColors(in: [displayLap, displayTotal, [totalLabel]])
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension StopwatchTableViewCell {
    //MARK: Display functions
    
    func updateDisplay(_ timeInterval: TimeInterval, at display: [UILabel]?) {
        guard let display = display else {
            print("Labels not yet initialized")
            return
        }
        let time = StopwatchTime(time: timeInterval)
        if let hoursString = time.hoursString {
            display[0].text = hoursString
        } else {
            display[0].text = "00"
        }
        
        if let minutesString = time.minutesString {
            display[2].text = minutesString
        } else {
            display[2].text = "00"
        }
        
        display[4].text = time.secondsString
        display[5].text = time.fractionSecondsString
        
        if display.count > 6 {
            display[6].text = "Lap \(lapNumber)"
        }
    }
    
    func setLabelColors(in collections: [[UILabel]?]) {
        for collection in collections {
            guard let collection = collection else { return }
            for label in collection {
                label.textColor = InterfaceColor.offWhite
            }
        }
        
    }
}

//
//  StopWatchTableViewCell.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 26..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class StopWatchTableViewCell: UITableViewCell {
    
    
    
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
    
    var displayLap: [UILabel]?
    var displayTotal: [UILabel]?
    
    var lapNumber: Int = 0
    
    var totalTime: Int = 0 {
        didSet {
            updateDisplay(totalTime, at: displayTotal)
            
        }
    }
    
    
    var lapTime: Int = 0 {
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
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension StopWatchTableViewCell {
    //MARK: Display functions
    
    func updateDisplay(_ time: Int, at display: [UILabel]?) {
        guard let display = display else {
            print("Labels not yet initialized")
            return
        }
        let hours = time / 360000
        let minutes = ( time % 360000 ) / 6000
        let seconds = ( time % 6000 ) / 100
        let fractionSeconds = time % 100
        
        display[0].text = String(hours)
        display[2].text = String(format: "%02i", minutes)
        display[4].text = String(format: "%02i", seconds)
        display[5].text = String(format: "%02i", fractionSeconds)
        
        if display.count > 6 {
            display[6].text = "Lap \(lapNumber)"
        }
    }
    
}

//
//  StopwatchViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var hour1Label: UILabel!
    @IBOutlet weak var hour2Label: UILabel!
    @IBOutlet weak var hoursSeparator: UILabel!
    @IBOutlet weak var minute1Label: UILabel!
    @IBOutlet weak var minute2Label: UILabel!
    @IBOutlet weak var minutesSeparator: UILabel!
    @IBOutlet weak var second1Label: UILabel!
    @IBOutlet weak var second2Label: UILabel!
    @IBOutlet weak var secondsSeparator: UILabel!
    @IBOutlet weak var fractionSecond1Label: UILabel!
    @IBOutlet weak var fractionSecond2Label: UILabel!
    
    @IBOutlet weak var displayStackView: UIStackView!
    
    @IBOutlet weak var smallHour1Label: UILabel!
    @IBOutlet weak var smallHour2Label: UILabel!
    @IBOutlet weak var smallHoursSeparator: UILabel!
    @IBOutlet weak var smallMinute1Label: UILabel!
    @IBOutlet weak var smallMinute2Label: UILabel!
    @IBOutlet weak var smallMinutesSeparator: UILabel!
    @IBOutlet weak var smallSecond1Label: UILabel!
    @IBOutlet weak var smallSecond2Label: UILabel!
    @IBOutlet weak var smallSecondsSeparator: UILabel!
    @IBOutlet weak var smallFractionSecond1Label: UILabel!
    @IBOutlet weak var smallFractionSecond2Label: UILabel!
    @IBOutlet weak var smallDisplayStackView: UIStackView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    var labelCollections: [LabelCollection] = []
    
    let green = UIColor(red: 106/255, green: 242/255, blue: 84/255, alpha: 1)
    
    var isFirstLap = true {
        didSet {
            if isFirstLap {
                smallDisplayStackView.isHidden = true
            } else {
                smallDisplayStackView.isHidden = false
            }
        }
    }
    
    var stopWatch: Timer? = nil {
        didSet {
            if stopWatch == nil {
                startButton.setBackgroundImage(#imageLiteral(resourceName: "startButton"), for: .normal)
                startButton.setTitle("Start", for: .normal)
                lapButton.setTitle("Reset", for: .normal)
                
            } else {
                // necessary for not getting optional crash after coming from timer view without opening Stopwatch screen first
                //guard let startButton = startButton else { return }
                //guard let lapButton = lapButton else { return }
                
                startButton.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
                startButton.setTitle("Stop", for: .normal)
                lapButton.setTitle("Lap", for: .normal)
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
        didSet {
            guard totalTime < 86400 else {
                startDate = startDate?.addingTimeInterval(86400)
                totalTime = totalTime - 86400
                return
            }
            updateNewDisplay(totalTime, for: labelCollections[1])
        }
    }
    
    var lapTime: TimeInterval = 0 {
        didSet {
            updateNewDisplay(lapTime, for: labelCollections[0])
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // necessary to show correct buttons if coming from timer view
        labelCollections = [LabelCollection(itemMultiplier: 1,
                                            stackView: displayStackView,
                                            labels: [hour1Label,
                                                     hour2Label,
                                                    hoursSeparator,
                                                    minute1Label,
                                                    minute2Label,
                                                    minutesSeparator,
                                                    second1Label,
                                                    second2Label,
                                                    secondsSeparator,
                                                    fractionSecond1Label,
                                                    fractionSecond2Label]),
                            LabelCollection(itemMultiplier: 1,
                                            stackView: smallDisplayStackView,
                                            labels: [smallHour1Label,
                                                     smallHour2Label,
                                                     smallHoursSeparator,
                                                     smallMinute1Label,
                                                     smallMinute2Label,
                                                     smallMinutesSeparator,
                                                     smallSecond1Label,
                                                     smallSecond2Label,
                                                     smallSecondsSeparator,
                                                     smallFractionSecond1Label,
                                                     smallFractionSecond2Label])]
        
        
        
        
        updateNewDisplay(lapTime, for: labelCollections[0])
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        
        lapsTableView.separatorStyle = .none
        
        smallDisplayStackView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if startDate != nil && stopWatch == nil {
            startStopWatch(startedByUser: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let stopWatch = stopWatch {
            stopStopWatch(stopWatch, stoppedByUser: false)
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if let stopWatch = stopWatch {
            stopStopWatch(stopWatch, stoppedByUser: true)
        } else {
            startStopWatch(startedByUser: true)
        }
        
        
    }

    @IBAction func lapButtonTapped(_ sender: UIButton) {
        
        if stopWatch != nil {
            isFirstLap = false
            lapDate = Date()
            LapTime.addLap(totalTime)
            lapsTableView.reloadData()
        } else {
            startDate = nil
            lapDate = nil
            LapTime.laps = []
            isFirstLap = true
            lapsTableView.reloadData()
        }
        
    }
}

extension StopwatchViewController: StopwatchManager {
    
    func buttonsForRunning() {
        
    }
}

extension StopwatchViewController: StopwatchTimeDisplay {
    
}

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LapTime.laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stopWatchCell", for: indexPath) as! StopWatchTableViewCell
        let source = LapTime.laps[indexPath.row]
        
        cell.lapNumber = source.lapNumber
        cell.totalTime = source.totalTime
        cell.lapTime = source.lapTime
        
        
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        return cell
    }
}

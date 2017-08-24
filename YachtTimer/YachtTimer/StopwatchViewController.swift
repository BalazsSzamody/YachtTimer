//
//  StopwatchViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var fractionSecondsLabel: UILabel!
    @IBOutlet weak var hoursSeparator: UILabel!
    @IBOutlet weak var minutesSeparator: UILabel!
    @IBOutlet weak var secondsSeparator: UILabel!
    @IBOutlet weak var displayStackView: UIStackView!
    
    @IBOutlet weak var smallHoursLabel: UILabel!
    @IBOutlet weak var smallHoursSeparator: UILabel!
    @IBOutlet weak var smallMinutesLabel: UILabel!
    @IBOutlet weak var smallMinutesSeparator: UILabel!
    @IBOutlet weak var smallSecondsLabel: UILabel!
    @IBOutlet weak var smallSecondsSeparator: UILabel!
    @IBOutlet weak var smallFractionSeconds: UILabel!
    @IBOutlet weak var smallDisplayStackView: UIStackView!
    
    var labels: [UIStackView:[UILabel]]!
    
    var labelCollections: [LabelCollection] = []
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
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
            updateDisplay(totalTime, for: labelCollections[1])
        }
    }
    
    var lapTime: TimeInterval = 0 {
        didSet {
            updateDisplay(lapTime, for: labelCollections[0])
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // necessary to show correct buttons if coming from timer view
        /*
        if stopWatch != nil {
            startButton.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            startButton.setTitle("Stop", for: .normal)
            lapButton.setTitle("Lap", for: .normal)
        }
        */
        labelCollections = [LabelCollection(itemMultiplier: 1,
                                            stackView: displayStackView,
                                            labels: [hoursLabel,
                                                    hoursSeparator,
                                                    minutesLabel,
                                                    minutesSeparator,
                                                    secondsLabel,
                                                    secondsSeparator,
                                                    fractionSecondsLabel]),
                            LabelCollection(itemMultiplier: 0.8,
                                            stackView: smallDisplayStackView,
                                            labels: [smallHoursLabel,
                                                     smallHoursSeparator,
                                                     smallMinutesLabel,
                                                     smallMinutesSeparator,
                                                     smallSecondsLabel,
                                                     smallSecondsSeparator,
                                                     smallFractionSeconds])]
        
        labels = [displayStackView : [hoursLabel,
                                      hoursSeparator,
                                      minutesLabel,
                                      minutesSeparator,
                                      secondsLabel,
                                      secondsSeparator,
                                      fractionSecondsLabel],
                  smallDisplayStackView : [smallHoursLabel,
                                           smallHoursSeparator,
                                           smallMinutesLabel,
                                           smallMinutesSeparator,
                                           smallSecondsLabel,
                                           smallSecondsSeparator,
                                           smallFractionSeconds]
        ]
        
        
        updateDisplay(lapTime, for: labelCollections[0])
        
        
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
            stopStopWatch(stopWatch)
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if let stopWatch = stopWatch {
            stopStopWatch(stopWatch)
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
    
    func startStopWatch(startedByUser: Bool) {
        
        if startedByUser {
            if startDate == nil {
                startDate = Date()
            } else {
                startDate = Date().addingTimeInterval(-totalTime)
            }
            if lapDate == nil {
                lapDate = Date()
            } else {
                lapDate = Date().addingTimeInterval(-lapTime)
            }
        }
        
        
        stopWatch = Timer(timeInterval: 0.09, repeats: true) {_ in
            self.totalTime = Date().timeIntervalSince(self.startDate!)
            self.lapTime = Date().timeIntervalSince(self.lapDate!)
        }
        
        guard let stopWatch = stopWatch else { return }
            RunLoop.current.add(stopWatch, forMode: .commonModes)
    }
    
    func stopStopWatch(_ stopWatch: Timer) {
        stopWatch.invalidate()
        self.stopWatch = nil
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

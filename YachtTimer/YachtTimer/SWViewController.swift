//
//  StopwatchViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class SWViewController: UIViewController {

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
    
    @IBOutlet weak var interfaceStackView: UIStackView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    var buttonGroup: [UIButton] = []
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImage: UIImageView!
    @IBOutlet weak var closeOverlayLeftButton: UIButton!
    
    var labelCollections: [PhoneLabelCollection] = []
    
    let green = InterfaceColor.brightGreen
    let blue = InterfaceColor.blue
    let lightBlue = InterfaceColor.lightBlue
    let white = InterfaceColor.white
    let red = InterfaceColor.brightRed
    
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
            if !overlayView.isHidden {
                
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // necessary to show correct buttons if coming from timer view
        labelCollections = [PhoneLabelCollection(itemMultiplier: 1,
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
                            PhoneLabelCollection(itemMultiplier: 1,
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
        switchToStartButtons()
        setLabelColors()
        
        let multiplier = PhoneScreen.interfaceMultiplier
        interfaceStackView.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
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
            resetStopwatch()
        }
        
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func closeOverlayLeftButtonPressed(_ sender: Any) {
        
    }
}

extension SWViewController: StopwatchManager {
    
    func switchToStartButtons() {
        //setUpButton in UIButtonExtension
        startButton.setUpButton(image: #imageLiteral(resourceName: "startIcon"), color: green)
        lapButton.setUpButton(image: #imageLiteral(resourceName: "closeIcon"), color: red)
    }
    
    func switchToRunningButtons() {
        startButton.setUpButton(image: #imageLiteral(resourceName: "pauseIcon"), color: red)
        lapButton.setUpButton(image: #imageLiteral(resourceName: "resetIcon"), color: green)
    }
    
    func setLabelColors() {
        for collection in labelCollections {
            for label in collection.labels {
                label.textColor = white
            }
        }
    }
    
    func resetStopwatch() {
        startDate = nil
        lapDate = nil
        LapTime.laps = []
        isFirstLap = true
        lapsTableView.reloadData()
    }
}

extension SWViewController: StopwatchTimeDisplay {
    
}

extension SWViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LapTime.laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stopWatchCell", for: indexPath) as! SWTableViewCell
        let source = LapTime.laps[indexPath.row]
        
        cell.lapNumber = source.lapNumber
        cell.totalTime = source.totalTime
        cell.lapTime = source.lapTime
        
        
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        return cell
    }
}

extension SWViewController {
    //MARK: Overlay handling
   /*
    func prepareOverlaysAndButtons() {
        buttonGroup = [startButton, lapButton, helpButton]
        helpButton.setUpButton(image: #imageLiteral(resourceName: "QuestionMark"), color: blue)
        overlayView.backgroundColor = UIColor(white: 0.25, alpha: 0.35)
        setOverlayBackground()
        overlayView.isHidden = true
        settingsButton.isHidden = true
    }
    
    func prepareOverlayImage(isOrientationLandscape: Bool) {
        
        
        let orientationSet: HelpImageSet?
        if isOrientationLandscape {
            orientationSet = HelpImageSet.landscapeSet
        } else {
            orientationSet = HelpImageSet.portraitSet
        }
        if lapDate != startDate {
            overlayImage.image = orientationSet?.lappedStopwatchImage
        } else {
            overlayImage.image = orientationSet?.simpleStopwatchImage
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard isViewLoaded else { return }
        if !overlayView.isHidden {
            prepareOverlayImage(isOrientationLandscape: PhoneScreen.currentScreen.orientation)
        }
        
    }
 */
}

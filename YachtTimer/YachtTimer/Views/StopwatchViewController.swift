//
//  StopwatchViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    var totalTimeLabels: [UILabel]!
    var totalTimeDisplayElements: [UIView]!
    
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
    
    var lapTimeLabels: [UILabel]!
    var lapTimeDisplayElements: [UIView]!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    var buttonGroup: [UIButton] = []
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImage: UIImageView!
    @IBOutlet weak var closeOverlayLeftButton: UIButton!
    
    let viewModel = StopwatchViewViewModel()
    
    let disposeBag = DisposeBag()
    
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
        prepareForStart()
        bindTimeLabels()
        bindTimerIsRunning()
        bindDisplayHandling()
        
        
        
        
        
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
    
    private func bindTimeLabels() {
        bindTotalTimeLabels()
        bindLapTimeLabels()
    }
    
    private func bindTimerIsRunning() {
        viewModel.timerIsRunning.asObservable().subscribe(onNext: { [unowned self] timerIsRunning in
            if timerIsRunning {
                self.switchToRunningButtons()
            } else {
                self.switchToStartButtons()
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindDisplayHandling() {
        bindSeparators(for: .totalTime)
        bindSeparators(for: .lapTime)
    }
    
    private func bindSeparators(for timeComponentSet: StopwatchTimeComponentSet) {
        let timeComponents = getObservable(for: timeComponentSet)
        
        let combinedObservables = Observable
            .combineLatest(timeComponents[0].asObservable(),
                           timeComponents[1].asObservable(),
                           timeComponents[2].asObservable(),
                           timeComponents[3].asObservable()
                            ) { (h1, h2, m1, m2) in
                            return h1 + h2 + m1 + m2
                            }
        
        combinedObservables.asObservable().subscribe(onNext: { [unowned self] value in
            let displayElements = self.getDisplayElements(for: timeComponentSet)
            self.handleDisplayElements(displayElements, for: value)
        }).disposed(by: disposeBag)
        
    }
    
    private func getDisplayElements(for timeComponentSet: StopwatchTimeComponentSet) -> [UIView] {
        switch timeComponentSet {
        case .totalTime:
            return totalTimeDisplayElements
        case .lapTime:
            return lapTimeDisplayElements
        }
    }
    
    private func handleDisplayElements(_ displayElements: [UIView], for value: String) {
        
    }
    
    private func bindTotalTimeLabels() {
        bindLabels(.totalTime)
    }
    
    private func bindLapTimeLabels() {
        bindLabels(.lapTime)
    }
    
    private func bindLabels(_ timeComponentSet: StopwatchTimeComponentSet) {
        let timeComponents = getObservable(for: timeComponentSet)
        let labels = getLabels(for: timeComponentSet)
        timeComponents.enumerated().forEach { (arg) in
            let (i, timeComponent) = arg
            bindTimeComponent(timeComponent, to: labels[i])
        }
    }
    
    private func bindTimeComponent(_ timeComponent: Variable<String>, to label: UILabel) {
        timeComponent.asObservable().subscribe(onNext: { [unowned self] value in
            self.bind(value, to: label)
        }).disposed(by: disposeBag)
    }
    
    private func bind(_ value: String, to label: UILabel) {
        label.text = value
    }
    
    private func getObservable(for timeComponentSet: StopwatchTimeComponentSet) -> [Variable<String>] {
        switch timeComponentSet {
        case .totalTime:
            return viewModel.totalTime
        case .lapTime:
            return viewModel.lapTime
        }
    }
    
    private func getLabels(for timeComponentSet: StopwatchTimeComponentSet) -> [UILabel] {
        switch timeComponentSet {
        case .totalTime:
            return totalTimeLabels
        case .lapTime:
            return lapTimeLabels
        }
    }
}

extension StopwatchViewController: StopwatchManager {
    
    func prepareForStart() {
        totalTimeLabels = [hour1Label,
                           hour2Label,
                           minute1Label,
                           minute2Label,
                           second1Label,
                           second2Label,
                           fractionSecond1Label,
                           fractionSecond2Label]
        
        lapTimeLabels = [smallHour1Label,
                         smallHour2Label,
                         smallMinute1Label,
                         smallMinute2Label,
                         smallSecond1Label,
                         smallSecond2Label,
                         smallFractionSecond1Label,
                         smallFractionSecond2Label]
        
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
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.identifier, for: indexPath) as! StopwatchTableViewCell
        let source = LapTime.laps[indexPath.row]
        
        cell.lapNumber = source.lapNumber
        cell.totalTime = source.totalTime
        cell.lapTime = source.lapTime
        
        
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        return cell
    }
}

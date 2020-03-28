//
//  ViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    //@IBOutlet weak var secondLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var displayStackView: UIStackView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    
    var buttonGroup: [UIButton] = []
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImage: UIImageView!
    @IBOutlet weak var closeOverlayLeftButton: UIButton!
    
    @IBOutlet weak var upArrowButton: UIButton!
    @IBOutlet weak var downArrowButton: UIButton!
    @IBOutlet weak var phoneBackgroundImage: UIImageView!
    
    var counterReference: Int = 300
    var timer: Timer? = nil {
        didSet {
            if timer == nil {
                switchToStartButtons()
                UIApplication.shared.isIdleTimerDisabled = true
            } else {
                switchToRunningButtons()
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    let alert = TextToSpeech()
    
    let green = InterfaceColor.brightGreen
    let yellow = InterfaceColor.brightYellow
    let red = InterfaceColor.brightRed
    let blue = InterfaceColor.blue
    let lightBlue = InterfaceColor.lightBlue
    let white = InterfaceColor.white
    let transparent = InterfaceColor.transparent
    
    var counter: Int = 65 {
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
            updateDisplay(counter)
            
            if !overlayView.isHidden {
                
            }
 
        }
    }
    
    var endDate: Date? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        counter = counterReference
        setLabelColor(white)
        switchToStartButtons()
        guard let interfaceStackView = displayStackView.superview else { return }
        let multiplier = PhoneScreen.interfaceMultiplier
        interfaceStackView.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        if let timer = timer {
            stopTimer(timer)
        } else {
            startTimer()
        }
        
        
        
    }
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        syncResetTimer(timer, resetCompletionHandler: resetLabels)
    }
    @IBAction func swipeUp(_ sender: Any) {
        addMinute(failure: nil, completion: nil)
    }
    @IBAction func swipeDown(_ sender: Any) {
        subtractMinute(failure: nil, completion: nil)
    }
    @IBAction func upArrowPressed(_ sender: Any) {
        addMinute(failure: nil, completion: nil)
    }
    @IBAction func downArrowPressed(_ sender: Any) {
        subtractMinute(failure: nil, completion: nil)
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func closeOverlayLeftButtonPressed(_ sender: Any) {
       
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        
    }
    
    
}

extension ViewController: TimerManager {
    //MARK: Timer functions
    
    
    func counterFinished(_ timer: Timer) {
        let date = Date()
        
        stopTimer(timer)
        counter = counterReference
        if let stopWatchVC = self.tabBarController?.viewControllers?[1] as? StopwatchViewController {
            stopWatchVC.loadViewIfNeeded()
            stopWatchVC.resetStopwatch()
            stopWatchVC.startDate = date
            stopWatchVC.lapDate = date
            self.tabBarController?.selectedViewController = stopWatchVC
        }
        
    }
}

extension ViewController {
    //MARK: Label handling functions
    
    
    
    func updateDisplay(_ counter: Int) {
        let time = TimerTime(time: counter)
        
        if let minute = time.minutesString{
            minuteLabel.text = minute
            resetLabels()
        } else {
            enlargeSeconds()
        }
        
        secondLabel.text = time.secondsString
        
        manageLabels(counter)
    }
    
    func manageLabels(_ time: Int) {
        switch time{
        case 60 ... 119:
            setLabelColor(yellow)
            
        case 1 ... 59:
            setLabelColor(red)
        
        default:
            setLabelColor(white)
            
        }
    }
    
    func resetLabels() {
        minuteLabel.isHidden = false
        separatorLabel.isHidden = false
        
        timerStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func enlargeSeconds() {
        
        minuteLabel.isHidden = true
        separatorLabel.isHidden = true
        
        timerStackView.transform = CGAffineTransform(scaleX: 1.66, y: 1.66)
    }
    
    
    
    func setLabelColor(_ color: UIColor) {
        minuteLabel.textColor = color
        separatorLabel.textColor = color
        secondLabel.textColor = color
    }
    
}

extension ViewController {
    //MARK: Speech handling
    
    func manageSpeech(_ time: Int) {
        
        if counter % 60 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 120 && counter % 30 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 60 && counter % 15 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 30 && counter % 5 == 0 {
            alert.sayOutLoud(counter)
        } else if counter < 15 {
            alert.sayOutLoud(counter)
        } else if counter == 0 {
            alert.sayOutLoud("Start")
        }
        
    }
}

extension ViewController {
    //MARK: Control button handling
    
    func switchToStartButtons() {
        //setUpButton in UIButtonExtension
        startButton.setUpButton(image: #imageLiteral(resourceName: "startIcon"), color: green)
        syncButton.setUpButton(image: #imageLiteral(resourceName: "closeIcon"), color: red)
        upArrowButton.setUpButton(image: #imageLiteral(resourceName: "upArrows"), color: white)
        downArrowButton.setUpButton(image: #imageLiteral(resourceName: "downArrows"), color: white)
        upArrowButton.isHidden = false
        downArrowButton.isHidden = false
        }
    
    func switchToRunningButtons() {
        startButton.setUpButton(image: #imageLiteral(resourceName: "pauseIcon"), color: red)
        syncButton.setUpButton(image: #imageLiteral(resourceName: "syncIcon"), color: green)
        upArrowButton.isHidden = true
        downArrowButton.isHidden = true
    }
}

extension ViewController {
    //MARK: Overlay handling
    /*
    func prepareOverlaysAndButtons() {
        buttonGroup = [startButton, syncButton, helpButton]
        helpButton.setUpButton(image: #imageLiteral(resourceName: "QuestionMark"), color: blue)
        //overlayView.backgroundColor = UIColor(white: 0.25, alpha: 0.25)
        setOverlayBackground()
        overlayView.isHidden = true
        settingsButton.isHidden = true
    }
    
    func prepareOverlayImage(isOrientationLandscape: Bool) {
        overlayElements.append(OverlayElement.addElement(view: displayStackView, parentView: overlayView))
        overlayElements.append(OverlayElement.addElement(view: startButton, parentView: overlayView))
        
        if isOrientationLandscape {
            overlayImage.image = HelpImageSet.landscapeSet?.timerImage
        } else {
            //overlayImage.image = HelpImageSet.portraitSet?.timerImage
        }
     
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard isViewLoaded else { return }
        if !overlayView.isHidden {
            //prepareOverlayImage(isOrientationLandscape: PhoneScreen.currentScreen.orientation)
        }
        
    }
    */
}

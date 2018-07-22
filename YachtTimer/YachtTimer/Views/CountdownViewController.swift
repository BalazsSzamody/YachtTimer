//
//  ViewController.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 13..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountdownViewController: UIViewController {
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var displayStackView: UIStackView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    
    @IBOutlet weak var upArrowButton: UIButton!
    @IBOutlet weak var downArrowButton: UIButton!
    @IBOutlet weak var phoneBackgroundImage: UIImageView!
    
    var viewModel = CountdownViewViewModel()
    
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bindTimerIsRunning()
        bindLabels()
        bindTimerIsFinished()
        bindLabelColor()
        
        guard let interfaceStackView = displayStackView.superview else { return }
        let multiplier = PhoneScreen.interfaceMultiplier
        interfaceStackView.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        viewModel.startStop()
     }
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        viewModel.resetSync()
    }
    @IBAction func swipeUp(_ sender: Any) {
        viewModel.addMinute()
    }
    @IBAction func swipeDown(_ sender: Any) {
        viewModel.subtractMinute()
    }
    @IBAction func upArrowPressed(_ sender: Any) {
        viewModel.addMinute()
    }
    @IBAction func downArrowPressed(_ sender: Any) {
        viewModel.subtractMinute()
    }
    
    private func bindTimerIsRunning() {
        viewModel.timerIsRunning.asObservable().subscribe(onNext: { [unowned self] isRunning in
            if isRunning {
                self.switchToRunningButtons()
            } else {
                self.switchToStartButtons()
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindTimerIsFinished() {
        viewModel.timerIsFinished.asObservable().subscribe(onNext: { [unowned self] isFinished in
            self.counterFinished()
        }).disposed(by: disposeBag)
    }
    
    private func bindLabels() {
        viewModel.minute.asObservable().subscribe(onNext: { [unowned self] minute in
            if minute == "00" {
                self.enlargeSeconds()
            } else {
                self.resetLabels()
                self.minuteLabel.text = minute
            }
        }).disposed(by: disposeBag)
        
        viewModel.second.asObservable().subscribe(onNext: { [unowned self] second in
            self.secondLabel.text = second
        }).disposed(by: disposeBag)
    }
    
    private func bindLabelColor() {
        viewModel.labelColor.asObservable().subscribe(onNext: { [unowned self] color in
            self.setLabelColor(color)
        }).disposed(by: disposeBag)
    }
    
}

extension CountdownViewController{
    //MARK: Timer functions
    
    
    func counterFinished() {
        print("Timer finished")
        /*if let stopWatchVC = self.tabBarController?.viewControllers?[1] as? StopwatchViewController {
            stopWatchVC.prepareForStart()
            stopWatchVC.resetStopwatch()
            stopWatchVC.startDate = date
            stopWatchVC.lapDate = date
            self.tabBarController?.selectedViewController = stopWatchVC
        }*/
        
    }
}

extension CountdownViewController {
    //MARK: Label handling functions
    
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

extension CountdownViewController {
    //MARK: Control button handling
    
    func switchToStartButtons() {
        //setUpButton in UIButtonExtension
        startButton.setUpButton(image: #imageLiteral(resourceName: "startIcon"), color: InterfaceColor.green)
        syncButton.setUpButton(image: #imageLiteral(resourceName: "closeIcon"), color: InterfaceColor.red)
        upArrowButton.setUpButton(image: #imageLiteral(resourceName: "upArrows"), color: InterfaceColor.white)
        downArrowButton.setUpButton(image: #imageLiteral(resourceName: "downArrows"), color: InterfaceColor.white)
        upArrowButton.isHidden = false
        downArrowButton.isHidden = false
        }
    
    func switchToRunningButtons() {
        startButton.setUpButton(image: #imageLiteral(resourceName: "pauseIcon"), color: InterfaceColor.red)
        syncButton.setUpButton(image: #imageLiteral(resourceName: "syncIcon"), color: InterfaceColor.green)
        upArrowButton.isHidden = true
        downArrowButton.isHidden = true
    }
}

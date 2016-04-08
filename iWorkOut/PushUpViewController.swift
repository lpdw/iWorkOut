//
//  PusUpViewController.swift
//  iWorkOut
//
//  Created by Yassin Aghani on 06/04/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import UIKit
import AVFoundation
import HealthKit

class PushUpViewController: UIViewController {
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var coutinglabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    var timer:NSTimer?
    var time = 0
    var counter = 0
    var pushState = false
    var workOut = WorkOut()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterLabel.layer.masksToBounds = true
        NSUserDefaults.standardUserDefaults().registerDefaults(["soundState": true])
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("soundState")){
            soundButton.setImage(UIImage(named:"sound"), forState: .Normal)
        } else {
            soundButton.setImage(UIImage(named:"noSound"), forState: .Normal)
        }
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            do{
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
                
            }
        }catch{
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        counterLabel.layer.cornerRadius = 100
        counter = 0
    }
    
    func enableProximitySensor(enable: Bool) {
        let device = UIDevice.currentDevice()
        device.proximityMonitoringEnabled = enable
        if (enable){
            print("Enable promixity sensor")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PushUpViewController.proximityChanged(_:)), name: "UIDeviceProximityStateDidChangeNotification", object: device)
        } else {
            print("Disable promixity sensor")
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    
    
    func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            if device.proximityState{
                counter += 1
                workOut.addActivity(PushUp())
                
                counterLabel.text = "\(counter)"
                if NSUserDefaults.standardUserDefaults().boolForKey("soundState"){
                    let utterance = AVSpeechUtterance(string: "\(counter)")
                    let synth = AVSpeechSynthesizer()
                    synth.speakUtterance(utterance)
                }
            }
        }
    }

    @IBAction func switchSound(sender: AnyObject) {
        var state = false
            
        if (NSUserDefaults.standardUserDefaults().boolForKey("soundState")){
            state = false
            soundButton.setImage(UIImage(named:"noSound"), forState: .Normal)
        } else {
            state = true
            soundButton.setImage(UIImage(named:"sound"), forState: .Normal)
        }
        
        NSUserDefaults.standardUserDefaults().setObject(state, forKey: "soundState")
    }

    func setTimer() {
        time += 1
        let minutes = time / 60
        let seconds = time % 60
        let formatedTime = String(format:"%02d:%02d", minutes, seconds)
        coutinglabel.text = formatedTime
    }

    //@IBAction func onclickPause(sender: AnyObject) {
      //  timer?.invalidate()
      //  playButton.setImage(UIImage(named:"pause"), forState: .Normal)
    //}
    
    @IBAction func onclickload(sender: AnyObject) {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.byValue = M_PI * 2
        rotate.duration = 0.25
        reloadButton.layer.addAnimation(rotate, forKey: "rotate")
        pushState = false
        enableProximitySensor(pushState)
        workOut.storeInHealthKit()
        self.workOut = WorkOut()
        
        counter = 0
        counterLabel.text = "\(counter)"
        time = 0
        coutinglabel.text = "00:00"
        timer?.invalidate()
        playButton.setImage(UIImage(named:"play"), forState: .Normal)
        
    }

    @IBAction func onclickPlay(sender: AnyObject) {
        let healthStore = HKHealthStore()
        
        let typesToShare: NSSet = {
            return NSSet(objects: HKWorkoutType.workoutType())
        }()
        
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(typesToShare as? Set<HKSampleType>, readTypes: typesToShare as? Set<HKSampleType>, completion: { (succeeded, error) in
                if succeeded && error == nil{
                    print("Successfully received authorization")
                }else{
                    if let theError = error{
                        print("Error occurred = \(theError)")
                    }
                }
            })
        } else {
            print("Health data is not available")
        }
    
        if pushState {
            timer?.invalidate()
            playButton.setImage(UIImage(named:"play"), forState: .Normal)
            pushState = false
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(setTimer), userInfo: nil, repeats: true)
            playButton.setImage(UIImage(named:"pause"), forState: .Normal)
            pushState = true
            workOut.storeInHealthKit()
            self.workOut = WorkOut()
        }
        enableProximitySensor(pushState)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

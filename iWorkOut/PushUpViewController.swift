//
//  PusUpViewController.swift
//  iWorkOut
//
//  Created by Yassin Aghani on 06/04/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import UIKit
import AVFoundation

class PushUpViewController: UIViewController {
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var coutinglabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    var timer:NSTimer?
    var time = 0
    var counter = 0
    var pushState = "1"
    

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
        
        activateProximitySensor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        counterLabel.layer.cornerRadius = 100
        counter = 0
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.hidden = true
    }
    
    func activateProximitySensor() {
        let device = UIDevice.currentDevice()
        device.proximityMonitoringEnabled = true
        if device.proximityMonitoringEnabled {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PushUpViewController.proximityChanged(_:)), name: "UIDeviceProximityStateDidChangeNotification", object: device)
        }
    }
    
    
    
    func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            if device.proximityState{
                counter += 1
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
        rotate.duration = 0.5
        reloadButton.layer.addAnimation(rotate, forKey: "rotate")
        

        counter = 0
        counterLabel.text = "\(counter)"
        time = 0
        coutinglabel.text = "00:00"
        timer?.invalidate()
        playButton.setImage(UIImage(named:"play"), forState: .Normal)
        
    }

    @IBAction func onclickPlay(sender: AnyObject) {
        if pushState == "1" {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(setTimer), userInfo: nil, repeats: true)
            playButton.setImage(UIImage(named:"pause"), forState: .Normal)
            pushState = "2"
        } else if pushState == "2" {
            timer?.invalidate()
            playButton.setImage(UIImage(named:"play"), forState: .Normal)
            pushState = "1"
            print(pushState)
        }

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

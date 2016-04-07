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
    var counter = 0

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

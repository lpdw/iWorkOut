//
//  FirstViewController.swift
//  iWorkOut
//
//  Created by Yassin Aghani on 06/04/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import UIKit

class StartPushUpViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startButton.layer.cornerRadius = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.hidden = false
    }

}


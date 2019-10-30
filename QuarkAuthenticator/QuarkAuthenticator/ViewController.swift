//
//  ViewController.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer!
    var installView: HWInstallView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = HWInstallView.init(frame: CGRect(x: 220, y: 220, width: GZ_HorizontalFlexible(value: 20), height: GZ_HorizontalFlexible(value: 20)))
        view.layer.cornerRadius = GZ_HorizontalFlexible(value: 10)
        view.layer.masksToBounds = true
        self.view.addSubview(view)
        installView = view
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }


    @objc func timeAction() {
        installView.progress += 0.01
    }
    
}


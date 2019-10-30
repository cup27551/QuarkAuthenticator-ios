//
//  RootViewController.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

let tokenStore: TokenStore = TokenStore()


class RootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
    }
    
    func initializeInterface() {
        self.view.backgroundColor = .white
        self.viewControllers = [MainViewController()]
//        self.viewControllers = [ViewController()]
        self.navigationBar.isHidden = true
    }
}

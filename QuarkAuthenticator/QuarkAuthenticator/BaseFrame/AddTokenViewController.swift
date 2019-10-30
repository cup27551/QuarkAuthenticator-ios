//
//  AddTokenViewController.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/15.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

typealias AddTokenSuccessBlock = () -> Void

class AddTokenViewController: UIViewController {
    
    lazy var topBarView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(GZSCREEN_WIDTH), height: STATUS_BAR_HEIGHT+44))
//        view.backgroundColor = GZColor(r: 28, g: 28, b: 40, a: 1)
        view.backgroundColor = GZColor(r: 108, g: 127, b: 255, a: 1)
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 5), y:CGFloat(STATUS_BAR_HEIGHT), width: GZ_HorizontalFlexible(value: 44), height: GZ_HorizontalFlexible(value: 44))
        button.setImage(UIImage.init(named:"返回"), for: .normal)
        button.rx.tap.subscribe({ (onNext) in
            self.backButtonAction()
        }).disposed(by: disposeBag)
        return button
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: GZSCREEN_WIDTH - GZ_HorizontalFlexible(value: 59), y:CGFloat(STATUS_BAR_HEIGHT), width: GZ_HorizontalFlexible(value: 44), height: GZ_HorizontalFlexible(value: 44))
        button.setImage(UIImage.init(named:"成功"), for: .normal)
        button.rx.tap.subscribe({ (onNext) in
            self.doneButtonAction()
        }).disposed(by: disposeBag)
        return button
    }()
    
    var issureTextField: UITextField!
    var accountTextField: UITextField!
    var secretKeyTextField: UITextField!
    public var callBack: AddTokenSuccessBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeInterface()
    }
    
    func initializeInterface() {
//        self.view.backgroundColor = GZColor(r: 28, g: 28, b: 40, a: 1)
        self.view.backgroundColor = GZColor(r: 108, g: 127, b: 255, a: 1)
        self.view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(doneButton)
        
        let defaultIssureLabel = UILabel.init(frame: .zero)
        defaultIssureLabel.text = "描述"
        defaultIssureLabel.textColor = .white
        defaultIssureLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        defaultIssureLabel.sizeToFit()
        defaultIssureLabel.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: topBarView.frameMaxY + GZ_VerticalFlexible(value: 30), width: defaultIssureLabel.frameWidth, height: defaultIssureLabel.frameHeight)
        self.view.addSubview(defaultIssureLabel)
        
        issureTextField = UITextField.init(frame: CGRect.init(x: defaultIssureLabel.frameMinX, y: defaultIssureLabel.frameMaxY+GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 345), height: GZ_VerticalFlexible(value: 40)))
        issureTextField.borderStyle = .roundedRect
        issureTextField.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        issureTextField.textColor = titleColor
        issureTextField.autocapitalizationType = .none
        issureTextField.autocorrectionType = .no
        issureTextField.placeholder = "Some Website"
        issureTextField.clearButtonMode = .whileEditing
        self.view.addSubview(issureTextField)
        
        let defaultAccountLabel = UILabel.init(frame: .zero)
        defaultAccountLabel.text = "账号"
        defaultAccountLabel.textColor = .white
        defaultAccountLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        defaultAccountLabel.sizeToFit()
        defaultAccountLabel.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: issureTextField.frameMaxY + GZ_VerticalFlexible(value: 30), width: defaultAccountLabel.frameWidth, height: defaultAccountLabel.frameHeight)
        self.view.addSubview(defaultAccountLabel)
        
        accountTextField = UITextField.init(frame: CGRect.init(x: defaultAccountLabel.frameMinX, y: defaultAccountLabel.frameMaxY+GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 345), height: GZ_VerticalFlexible(value: 40)))
        accountTextField.borderStyle = .roundedRect
        accountTextField.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        accountTextField.textColor = titleColor
        accountTextField.autocapitalizationType = .none
        accountTextField.autocorrectionType = .no
        accountTextField.placeholder = "user@example.com"
        accountTextField.clearButtonMode = .whileEditing
        self.view.addSubview(accountTextField)
        
        let defaultSecretKeyLabel = UILabel.init(frame: .zero)
        defaultSecretKeyLabel.text = "秘钥"
        defaultSecretKeyLabel.textColor = .white
        defaultSecretKeyLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        defaultSecretKeyLabel.sizeToFit()
        defaultSecretKeyLabel.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: accountTextField.frameMaxY + GZ_VerticalFlexible(value: 30), width: defaultSecretKeyLabel.frameWidth, height: defaultSecretKeyLabel.frameHeight)
        self.view.addSubview(defaultSecretKeyLabel)
        
        secretKeyTextField = UITextField.init(frame: CGRect.init(x: defaultAccountLabel.frameMinX, y: defaultSecretKeyLabel.frameMaxY+GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 345), height: GZ_VerticalFlexible(value: 40)))
        secretKeyTextField.borderStyle = .roundedRect
        secretKeyTextField.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        secretKeyTextField.textColor = titleColor
        secretKeyTextField.autocapitalizationType = .none
        secretKeyTextField.autocorrectionType = .no
        secretKeyTextField.placeholder = "... ... ..."
        secretKeyTextField.isSecureTextEntry = true
        secretKeyTextField.clearButtonMode = .whileEditing
        self.view.addSubview(secretKeyTextField)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonAction() {
        if secretKeyTextField.text?.count != 0 {
            let success = tokenStore.tokenVerify(issure: issureTextField.text!, account: accountTextField.text!, secret: secretKeyTextField.text!)
            if success {
                callBack!()
            }else {
                GZAlertView.showAlertTextView(text: "秘钥无效", delay: 1.5)
            }
        }else {
            GZAlertView.showAlertTextView(text: "秘钥不能为空", delay: 1.5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

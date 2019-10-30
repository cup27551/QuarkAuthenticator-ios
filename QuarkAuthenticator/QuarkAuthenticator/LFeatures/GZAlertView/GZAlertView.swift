//
//  GZAlertView.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/16.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

class GZAlertView: UIView {
    var contentView: UIView!
    var titleLabel: UILabel!
    var contextLabel: UILabel!
    var cancelButton: UIButton!
    var sureButton: UIButton!
    var sureLabel: UILabel!
    var cancelLabel: UILabel!
    public var callBack: AddTokenSuccessBlock?

    
    convenience init(title: String, contextStr: String, cancelStr: String, sureStr: String) {
        self.init(frame: UIScreen.main.bounds)
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.init(white: 0.1, alpha: 0.5)
        
        contentView = UIView.init(frame: CGRect(x: GZ_HorizontalFlexible(value: 35), y: 0, width: GZ_HorizontalFlexible(value: 305), height: 0))
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        self.addSubview(contentView)
        
        
        
        titleLabel = UILabel.init(frame: .zero)
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 24))
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = true
        let titleSize = calculatLabelSize(label: titleLabel, width: GZ_HorizontalFlexible(value: 275))
        titleLabel.frame = CGRect(x: GZ_HorizontalFlexible(value: 15), y: GZ_VerticalFlexible(value: 25), width: GZ_HorizontalFlexible(value: 275), height: titleSize.height)
        contentView.addSubview(titleLabel)

        contextLabel = UILabel.init(frame: .zero)
        contextLabel.text = contextStr
        contextLabel.textColor = .gray
        contextLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 16))
        contextLabel.numberOfLines = 0
        let contextSize = calculatLabelSize(label: contextLabel, width: GZ_HorizontalFlexible(value: 275))
        contextLabel.frame = CGRect(x: GZ_HorizontalFlexible(value: 15), y: GZ_VerticalFlexible(value: 15)+titleLabel.frameMaxY, width: GZ_HorizontalFlexible(value: 275), height: contextSize.height)
        contextLabel.isUserInteractionEnabled = true
        contentView.addSubview(contextLabel)
        
        
        
        sureLabel = UILabel.init(frame: .zero)
        sureLabel.text = sureStr
        sureLabel.textColor = .red
        sureLabel.textAlignment = .center
        sureLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 16))
        sureLabel.numberOfLines = 0
        sureLabel.isUserInteractionEnabled = true
        sureLabel.frame = CGRect(x: contentView.frameWidth - GZ_HorizontalFlexible(value: 85), y: contextLabel.frameMaxY + GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 70), height: GZ_VerticalFlexible(value: 35))
        contentView.addSubview(sureLabel)
        
        let sureTap = UITapGestureRecognizer.init(target: self, action: #selector(sureButtonAction))
        sureLabel.addGestureRecognizer(sureTap)
        
        cancelLabel = UILabel.init(frame: .zero)
        cancelLabel.text = cancelStr
        cancelLabel.textColor = .gray
        cancelLabel.textAlignment = .center
        cancelLabel.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 16))
        cancelLabel.numberOfLines = 0
        cancelLabel.isUserInteractionEnabled = true
        cancelLabel.frame = CGRect(x: sureLabel.frameMinX - GZ_HorizontalFlexible(value: 60), y: contextLabel.frameMaxY + GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 45), height: GZ_VerticalFlexible(value: 35))
        contentView.addSubview(cancelLabel)
        
        let cancelTap = UITapGestureRecognizer.init(target: self, action: #selector(cancelButtonAction))
        cancelLabel.addGestureRecognizer(cancelTap)
        
//        sureButton = UIButton.init(type: .custom)
//        sureButton.frame = CGRect(x: contentView.frameWidth - GZ_HorizontalFlexible(value: 85), y: contextLabel.frameMaxY + GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 70), height: GZ_VerticalFlexible(value: 35))
//        sureButton.setTitle(sureStr, for: .normal)
//        sureButton.setTitleColor(.red, for: .normal)
//        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 16))
//        sureButton.addTarget(self, action: #selector(sureButtonAction(sender:)), for: .touchDragInside)
//        sureButton.isEnabled = false
//        contentView.addSubview(sureButton)

//        cancelButton = UIButton.init(type: .custom)
//        cancelButton.frame = CGRect(x: sureButton.frameMinX - GZ_HorizontalFlexible(value: 60), y: contextLabel.frameMaxY + GZ_VerticalFlexible(value: 10), width: GZ_HorizontalFlexible(value: 45), height: GZ_VerticalFlexible(value: 35))
//        cancelButton.setTitle(cancelStr, for: .normal)
//        cancelButton.setTitleColor(.gray, for: .normal)
//        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 16))
//        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchDragInside)
//        cancelButton.isEnabled = false
//        contentView.addSubview(cancelButton)

        contentView.frameHeight = cancelLabel.frameMaxY + GZ_VerticalFlexible(value: 25)
        contentView.centerY = screenHeight * 0.5
    }
    
    class func showAlertTextView(text: String,delay: TimeInterval) {
        let contentView = UIView.init(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(contentView)
        
        let displayView = UIView.init(frame: .zero)
        displayView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.5)
//        displayView.layer.cornerRadius = GZ_HorizontalFlexible(value: 5)
//        displayView.layer.masksToBounds = true
        contentView.addSubview(displayView)
        
        
        let iconImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GZ_HorizontalFlexible(value: 15), height: GZ_HorizontalFlexible(value: 15)))
        iconImageView.image = UIImage.init(named: "warn")
        displayView.addSubview(iconImageView)
        
        let textLabel = UILabel.init(frame: .zero)
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.textColor = titleColor
        textLabel.font = settingPingFangFont(size: GZ_VerticalFlexible(value: 14), type: 1)
        textLabel.numberOfLines = 0
        let size: CGSize = calculatLabelSize(label: textLabel,width:GZ_HorizontalFlexible(value: 230))
        textLabel.frame = CGRect(x: 0, y:0, width: size.width, height: size.height)
        displayView.addSubview(textLabel)
        
        if size.width < GZ_HorizontalFlexible(value: 225) {
            displayView.frameHeight = textLabel.frameHeight + GZ_VerticalFlexible(value: 25)
            displayView.frameWidth = textLabel.frameWidth + iconImageView.frameWidth + GZ_HorizontalFlexible(value: 5) + GZ_HorizontalFlexible(value: 60)
            displayView.center = CGPoint(x: contentView.frameWidth * 0.5, y: contentView.frameHeight * 0.5 - GZ_VerticalFlexible(value: 50))
            
            iconImageView.originX = GZ_HorizontalFlexible(value: 30)
            iconImageView.centerY = displayView.frameHeight * 0.5
            
            textLabel.frame = CGRect(x: iconImageView.frameMaxX + GZ_HorizontalFlexible(value: 5), y: 0, width: textLabel.frameWidth, height: displayView.frameHeight)
            
        }else {
            iconImageView.centerX = GZ_HorizontalFlexible(value: 140)
            iconImageView.originY = GZ_VerticalFlexible(value: 10)
            
            textLabel.centerX = iconImageView.centerX
            textLabel.originY = iconImageView.frameMaxY + GZ_VerticalFlexible(value: 10)
            
            displayView.frameWidth = GZ_HorizontalFlexible(value: 280)
            displayView.frameHeight = textLabel.frameMaxY + GZ_VerticalFlexible(value: 20)
            displayView.center = CGPoint(x: contentView.frameWidth * 0.5, y: contentView.frameHeight * 0.5 - GZ_VerticalFlexible(value: 50))
        }
        
        contentView.viewHideDelay(timeInterval: delay)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
    @objc func sureButtonAction() {
        self.cancelButtonAction()
        self.callBack!()
    }
    
    @objc func test0() {
        print("0")
    }
    
    @objc func test1() {
        print("1")
    }
    
    @objc func test2() {
        print("2")
    }
    
    @objc func test3() {
        print("3")
    }

    
}

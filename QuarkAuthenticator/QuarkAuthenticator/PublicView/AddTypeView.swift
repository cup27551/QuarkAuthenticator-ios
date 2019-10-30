//
//  AddTypeView.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

class AddTypeView: UIView {
    
    lazy var containtView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: GZSCREEN_HEIGHT, width: GZSCREEN_WIDTH, height: GZ_VerticalFlexible(value: 120)+CGFloat(BOTTOM_HEIGHT)))
//        view.backgroundColor = GZColor(r: 28, g: 28, b: 40, a: 1)
        view.backgroundColor = GZColor(r: 108, g: 127, b: 255, a: 1)
        return view
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 20), y:0, width: containtView.frameWidth - GZ_HorizontalFlexible(value: 40), height: GZ_VerticalFlexible(value: 60))
        button.setTitle("   扫描二维码", for: .normal)
        button.setImage(UIImage.init(named:"扫一扫"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var writeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 20), y:cameraButton.frameMaxY, width: containtView.frameWidth - GZ_HorizontalFlexible(value: 40), height: GZ_VerticalFlexible(value: 60))
        button.setImage(UIImage.init(named:"编辑"), for: .normal)
        button.setTitle("   手动输入验证码", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 15))
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        self.addSubview(containtView)
        containtView.addSubview(cameraButton)
        containtView.addSubview(writeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    func show(superView: UIView) {
        superView.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.containtView.originY = GZSCREEN_HEIGHT - self.containtView.frameHeight
        }) { (animated) in
            
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.containtView.originY = GZSCREEN_HEIGHT 
        }) { (animated) in
            self.removeFromSuperview()
        }
    }
    
}

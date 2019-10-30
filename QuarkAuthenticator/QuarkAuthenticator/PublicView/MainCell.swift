//
//  MainCell.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

class MainCell: MGSwipeTableCell {
    var timer: Timer?
    
    lazy var bannerView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GZSCREEN_WIDTH, height: GZ_VerticalFlexible(value: 150)))
//        view.backgroundColor = GZColor(r: 35, g: 35, b: 49, a: 1)
//        view.backgroundColor = GZColor(r: 88, g: 175, b: 243, a: 1)
        
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: 0, width: bannerView.frameWidth - GZ_HorizontalFlexible(value: 30), height: GZ_VerticalFlexible(value: 45)))
        label.textAlignment = .left
//        label.textColor = GZColor(r: 125, g: 211, b: 195, a: 1)
        label.textColor = titleColor
        label.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 13))
        return label
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: GZ_VerticalFlexible(value: 45), width: bannerView.frameWidth - GZ_HorizontalFlexible(value: 30), height: GZ_VerticalFlexible(value: 60)))
        label.textAlignment = .left
        label.textColor = GZColor(r: 108, g: 127, b: 255, a: 1)
        label.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 52))
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: GZ_HorizontalFlexible(value: 15), y:codeLabel.frameMaxY, width: bannerView.frameWidth - GZ_HorizontalFlexible(value: 30), height: GZ_VerticalFlexible(value: 45)))
        label.textAlignment = .left
//        label.textColor = GZColor(r: 125, g: 211, b: 195, a: 1)
        label.textColor = titleColor
        label.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 13))
        return label
    }()
    
    lazy var installView: HWInstallView = {
        let view = HWInstallView.init(frame: CGRect.init(x: bannerView.frameWidth - GZ_HorizontalFlexible(value: 35), y: GZ_VerticalFlexible(value: 80), width: GZ_HorizontalFlexible(value: 20), height: GZ_HorizontalFlexible(value: 20)))
        view.layer.cornerRadius = GZ_HorizontalFlexible(value: 10)
        view.layer.masksToBounds = true
        return view
    }()
    
    deinit {
        timer?.invalidate()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
//        self.backgroundColor = GZColor(r: 35, g: 35, b: 49, a: 1)
        self.backgroundColor = .white
//        self.contentView.addSubview(bannerView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(codeLabel)
        self.contentView.addSubview(addressLabel)
        self.contentView.addSubview(installView)
        
        let lineView = UIView.init(frame: CGRect(x: 0, y: GZ_VerticalFlexible(value: 160) - 1, width: screenWidth, height: 1))
        lineView.backgroundColor = GZColor(r: 46,g: 53,b: 170,a: 1)
        self.contentView.addSubview(lineView)
        
        
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(updateCircleView), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timer?.fireDate = .distantFuture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func didTransition(to state: UITableViewCell.StateMask) {
//        super .didTransition(to: state)
//        for view in self.subviews {
//            if type(of: view.self).description() == "UITableViewCellEditControl" {
//                self.bannerView.frameMinX = view.frameWidth
//                
//                
//            }
//        }
//    }
    
    func settingTimeData(data: Double) {
        timer?.fireDate = .distantPast
//        installView.progress = CGFloat(1/(30-data))
        installView.progress = CGFloat(data/30)
    }
    
    @objc func updateCircleView() {
//        installView.settingNewProgress(newProgress: installView.progress+1/30.0)
//        installView.settingNewProgress(newProgress: 0.01+installView.progress)
        if installView.progress > 1 {
            timer?.fireDate = .distantFuture
            return
        }
        installView.progress += 1/30.0
    }
}

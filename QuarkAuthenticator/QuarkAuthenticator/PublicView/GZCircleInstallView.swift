//
//  GZCircleInstallView.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/12.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

class GZCircleInstallView: UIView {
    var progress: Double = 0
    
    func settingNewProgress(newProgress: Double) {
        progress = newProgress
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let xCenter = rect.size.width * 0.5
        let yCenter = rect.size.height * 0.5
        let radius = min(rect.size.width, rect.size.height) * 0.5
        
        appTintColor.set()
        let lineW = max(rect.size.width, rect.size.height) * 0.5
        context?.setLineWidth(lineW)
        context?.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius + lineW * 0.5 + 5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context?.strokePath()
        
        context?.setLineWidth(1)
        context?.move(to: CGPoint(x: xCenter, y: yCenter))
        context?.addLine(to: CGPoint(x: xCenter, y: 0))
        let endAngle = -Double.pi * 0.5 + progress * Double.pi * 2 + 0.001
        context?.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius, startAngle: CGFloat(-Double.pi * 0.5), endAngle: CGFloat(endAngle), clockwise: true)
        context?.fillPath()
    }
}

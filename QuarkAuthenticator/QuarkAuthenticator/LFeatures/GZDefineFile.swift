//
//  GZDefineFile.swift
//  QKBill
//
//  Created by quark on 2019/7/9.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

let TAG_NUMBER = 1000

let GZSCREEN_WIDTH = UIScreen.main.bounds.size.width
let GZSCREEN_HEIGHT = UIScreen.main.bounds.size.height

let gz_reference_width: CGFloat = 375.0
let gz_reference_height: CGFloat = 812

let GZ_SCREENT_WIDTH_RATIO =  GZSCREEN_WIDTH / gz_reference_width
let GZ_SCREENT_HEIGHT_RATIO = GZSCREEN_HEIGHT / gz_reference_height

let IS_IPHONE_X: Bool! = GZSCREEN_HEIGHT >= 812 ? true : false
let STATUS_BAR_HEIGHT = IS_IPHONE_X ? 44 : 20
let BOTTOM_HEIGHT = IS_IPHONE_X ? 20 : 0

func GZ_HorizontalFlexible(value: CGFloat) -> CGFloat {
    return value * GZ_SCREENT_WIDTH_RATIO
}

func GZ_VerticalFlexible(value: CGFloat) -> CGFloat {
    return value * GZ_SCREENT_HEIGHT_RATIO
}


//MARK:=========================Color=========================
func GZColor(r: CGFloat, g: CGFloat, b: CGFloat,a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func GZRandomColor() -> UIColor {
    return GZColor(r: CGFloat(arc4random()%256), g: CGFloat(arc4random()%256), b: CGFloat(arc4random()%256), a: 1)
}

func GZRCGColorFromeHex(rgbValue: Int) -> UIColor {
    return GZColor(r: (CGFloat)((rgbValue & 0xFF0000) >> 16), g: (CGFloat)((rgbValue & 0xFF00) >> 8), b: (CGFloat)(rgbValue & 0xFF), a: 1)
}

//MARK:=========================Font=========================
func gzFontNormal(x: CGFloat) -> UIFont {
    return UIFont.init(name: "DIN-MEDIUM", size: x)!
}

func settingPingFangFont(size: CGFloat,type:NSInteger) -> UIFont {
    //0是Bold 1是Medium
    if type == 0 {
        return UIFont.init(name:"PingFangSC-Semibold", size: size)!
    }else {
        return UIFont.init(name: "PingFangSC-Medium", size: size)!
    }
}

func calculatLabelSize(label: UILabel,width:CGFloat) -> CGSize {
    let string: NSString = label.text! as NSString
    let attributes = [NSAttributedString.Key.font:label.font]
    let boundingRect = string.boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
    return boundingRect.size
}


//MARK:=========================This APP=========================
let height_navationBar: CGFloat = IS_IPHONE_X ? 88.0 : 64.0
let height_tabbar: CGFloat = IS_IPHONE_X ? 82.0 : 48

let titleColor = GZColor(r: 46,g: 53,b: 70,a: 1)
let describColor = GZColor(r: 189, g: 195, b: 209, a: 1)
let describGrayColor = GZColor(r: 175, g: 181, b: 197, a: 1)
let grayLineColor = GZColor(r: 240,g: 240,b:240,a: 1)
let appTintColor = GZColor(r: 35, g: 35, b: 49, a: 1)

let contactColors:Array = [0xf7af42,0x959af4,0x77bcfe,0xff727f,0x96d862]

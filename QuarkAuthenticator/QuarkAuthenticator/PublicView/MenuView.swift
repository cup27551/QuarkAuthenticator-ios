//
//  MenuView.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol MenuViewDelegate {
    func didSeletedSendFeedBackButton()
    
}

let kMenuViewCellIdentifier = "kMenuViewCellIdentifier"

class MenuView: UIView {
    let titleStrArr = Observable.just(["发送反馈","服务条款","隐私权政策","法律声明"])
    
    lazy var shadeView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GZSCREEN_WIDTH, height: GZSCREEN_HEIGHT))
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(respondsToTapGesture(gesture:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var containtView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: -GZSCREEN_WIDTH*2/3, y: 0, width: GZSCREEN_WIDTH*2/3, height: GZSCREEN_HEIGHT))
//        view.backgroundColor = GZColor(r: 30, g: 30, b: 30, a: 1)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var menuViewTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(STATUS_BAR_HEIGHT), width: containtView.frameWidth, height: containtView.frameHeight - CGFloat(STATUS_BAR_HEIGHT)-44), style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = GZ_VerticalFlexible(value: 44)
        tableView.separatorStyle = .none
        tableView.register(MenuViewCell.self, forCellReuseIdentifier: kMenuViewCellIdentifier)
        tableView.bounces = false
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shadeView.addSubview(containtView)
        containtView.addSubview(menuViewTableView)
        self.addSubview(shadeView)
        loadMenuData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadMenuData() {
        titleStrArr.bind(to: menuViewTableView.rx.items(cellIdentifier: kMenuViewCellIdentifier, cellType: MenuViewCell.self)) { (row, element, cell) in
            cell.titleLabel.text = element
        }.disposed(by: disposeBag)
    }
    
    func show(superView: UIView) {
        superView.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.containtView.originX = 0
        }) { (animated) in

        }
    }
    
    func dismissMenuView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.containtView.originX = -GZSCREEN_WIDTH*2/3
        }) { (animated) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: Action
    @objc func respondsToTapGesture(gesture: UITapGestureRecognizer) {
        dismissMenuView()
    }
    
}

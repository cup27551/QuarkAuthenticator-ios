//
//  MenuViewCell.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: 0, width: GZSCREEN_WIDTH*2/3 - GZ_HorizontalFlexible(value: 30), height: GZ_VerticalFlexible(value: 44)))
        label.textAlignment = .left
        label.textColor = appTintColor
        label.font = UIFont.systemFont(ofSize: GZ_HorizontalFlexible(value: 16))
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: GZ_HorizontalFlexible(value: 15), y: GZ_VerticalFlexible(value: 44) - 1, width: titleLabel.frameWidth + GZ_HorizontalFlexible(value: 15), height: 1))
        view.backgroundColor = appTintColor
        view.alpha = 0.7
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  MainViewController.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/11.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import OneTimePassword

let disposeBag = DisposeBag()
let kMainCellIdentifier = "kMainCellIdentifier"

class MainViewController: UIViewController {
//    var token: Token? = nil
    
    
    lazy var topBarView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(GZSCREEN_WIDTH), height: STATUS_BAR_HEIGHT+44))
//        view.backgroundColor = GZColor(r: 28, g: 28, b: 40, a: 1)
        view.backgroundColor = GZColor(r: 108, g: 127, b: 255, a: 1)
        return view
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: GZ_HorizontalFlexible(value: 15), y:CGFloat(STATUS_BAR_HEIGHT), width: GZ_HorizontalFlexible(value: 44), height: GZ_HorizontalFlexible(value: 44))
//        button.setImage(UIImage.init(named:"菜单"), for: .normal)
        button.setTitle("账户", for: .normal)
        button.rx.tap.subscribe({ (onNext) in
//            self.menuButtonAction()
        }).disposed(by: disposeBag)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: GZSCREEN_WIDTH - GZ_HorizontalFlexible(value: 59), y:CGFloat(STATUS_BAR_HEIGHT), width: GZ_HorizontalFlexible(value: 44), height: GZ_HorizontalFlexible(value: 44))
        button.setImage(UIImage.init(named:"编辑"), for: .normal)
        button.setImage(UIImage.init(named: "成功"), for: .selected)
        button.rx.tap.subscribe({ (onNext) in
            button.isSelected = !button.isSelected
            self.editButtonAction()
        }).disposed(by: disposeBag)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x:editButton.frameMinX - GZ_HorizontalFlexible(value: 44), y:CGFloat(STATUS_BAR_HEIGHT), width: GZ_HorizontalFlexible(value: 44), height: GZ_HorizontalFlexible(value: 44))
        button.setImage(UIImage.init(named:"添加"), for: .normal)
        button.rx.tap.subscribe({ (onNext) in
            self.addButtonAction()
        }).disposed(by: disposeBag)
        return button
    }()
    
    lazy var mainView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: topBarView.frameMaxY, width: self.view.frameWidth, height:self.view.frameHeight - topBarView.frameMaxY), style: .plain)

        tableView.rowHeight = GZ_VerticalFlexible(value: 160)
        tableView.separatorStyle = .none
        tableView.register(MainCell.self, forCellReuseIdentifier: kMainCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    lazy var menuView: MenuView = {
        let view = MenuView.init(frame: CGRect.init(x: 0, y: 0, width: GZSCREEN_WIDTH, height: GZSCREEN_HEIGHT))
        return view
    }()
    
    lazy var addTypeView: AddTypeView = {
        let view = AddTypeView.init(frame: .zero)
        
        view.cameraButton.rx.tap.subscribe({ (onNext) in
            self.qrCodeButtonAction()
        }).disposed(by: disposeBag)

        view.writeButton.rx.tap.subscribe({ (onNext) in
            self.writeButtonAction()
        }).disposed(by: disposeBag)
        
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.text = "暂无验证码\n\n点击”+“创建账户"
        label.textColor = titleColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: 0, width: label.frameWidth, height: label.frameHeight)
        label.center = self.view.center
        label.isHidden = true
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(addButtonAction))
        label.addGestureRecognizer(tap)
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        regestierNotification()
        initializeInterface()
//        loadMainData()
        initializeData()
    }

    func regestierNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateAllData), name: NSNotification.Name(rawValue: "HaveNewDateNeedToUpdate"), object: nil)
    }
    
    func initializeInterface() {
        self.view.backgroundColor = .white
        topBarView.addSubview(menuButton)
        topBarView.addSubview(editButton)
        topBarView.addSubview(addButton)
        self.view.addSubview(topBarView)
        self.view.addSubview(mainView)
        self.view.addSubview(emptyLabel)
    }
    
    func initializeData() {
        tokenStore.loadToken { (success) in
            if success {
                self.loadMainData()
                self.mainView.reloadData()
            }else {
                //地址存储有误，全部清除
//                tokenStore.clearAllUrlString()
            }
        }
    }
    
    //MARK:Method
    func loadMainData() {

        if tokenStore.tokenList!.count == 0 {
            //显示空状态
            emptyLabel.isHidden = false
        }else {
            emptyLabel.isHidden = true
        }
    }
    

    
    @objc func updateAllData() {
        DispatchQueue.main.async {
            self.loadMainData()
            self.mainView.reloadData()
        }
    }
    
    //MARK: Action
    @objc func menuButtonAction() {
        self.menuView.show(superView: self.view)
    }
    
    @objc func addButtonAction() {
        self.addTypeView.show(superView: self.view)
    }

    @objc func editButtonAction() {
        self.mainView.isEditing = !self.mainView.isEditing
    }
    
    @objc func qrCodeButtonAction() {
        self.addTypeView.dismiss()
        let scannervc = ScannerVC()
        scannervc.setupScanner("扫一扫", appTintColor, .grid, "请将二维码放入框内，即可自动扫描") { (resultString) in
            scannervc.dismiss(animated: true, completion: nil)
            let success = tokenStore.tokenVerify(urlString: resultString)
            if success {
                self.loadMainData()
                self.mainView.reloadData()
            }else {
                print("error")
            }
        }
        self.present(scannervc, animated: true, completion: nil)
    }

    @objc func writeButtonAction() {
        self.addTypeView.dismiss()
        let addTokenVC = AddTokenViewController()
        addTokenVC.callBack = {() -> () in
            self.loadMainData()
            self.mainView.reloadData()
            addTokenVC.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(addTokenVC, animated: true)
    }

}

extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tokenStore.tokenList!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMainCellIdentifier) as! MainCell
        let token = tokenStore.tokenList![indexPath.section]
        cell.titleLabel.text = token.issuer
        cell.codeLabel.text = token.currentPassword
        cell.addressLabel.text = token.name
        cell.settingTimeData(data: progress!)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return GZ_VerticalFlexible(value: 20)
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frameWidth, height: GZ_VerticalFlexible(value: 20)))
////        view.backgroundColor = GZColor(r: 28, g: 28, b: 40, a: 1)
//        view.backgroundColor = GZColor(r: 108, g: 127, b: 255, a: 1)
//        return view
//    }

    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.isEditing = false
            let alertView = GZAlertView.init(title: "删除此账号不会停用两步验证", contextStr: "您可能因此无法登陆自己的账号。在删除账号之前，请先停用两步验证，或者确保您可以通过其他方法生成验证码。", cancelStr: "取消", sureStr: "删除账号")
            self.navigationController?.view.addSubview(alertView)
            alertView.callBack = { () -> Void in
                tokenStore.deleteToken(index: indexPath.section, callBack: { (success) in
                    if success {
                        tableView.deleteSections([indexPath.section], with: .automatic)
                        GZAlertView.showAlertTextView(text: "已删除", delay: 1.5)
                        self.loadMainData()
                    }else {
                        GZAlertView.showAlertTextView(text: "删除有误", delay: 1.5)
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tokenStore.moveToke(sourceIndex: sourceIndexPath.section, destination: destinationIndexPath.section) { (success) in
            tableView.exchangeSubview(at: sourceIndexPath.section, withSubviewAt: destinationIndexPath.section)
        }
    }
    
    
    
}

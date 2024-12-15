//
//  WDCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//  个人中心页面

import UIKit
import RxGesture
import RxSwift

class WDCenterViewController: WDBaseViewController {
    
    var model: DataModel?
    
    var modelArray1: [String] = ["发票抬头", "我要开票", "客服中心", "微信通知", "邀请好友", "分享好友", "加入分销", "联系我们", "意见反馈", "团体中心"]
    
    var modelArray2: [String] = ["发票抬头", "我要开票", "客服中心", "微信通知", "邀请好友", "分享好友", "加入分销", "联系我们", "意见反馈"]
    
    lazy var centerView: UserCenterView = {
        let centerView = UserCenterView()
        return centerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //跳转设置页面
        centerView.setBtn.rx.tap.subscribe(onNext: { [weak self] in
            if IS_LOGIN {
                let settingVc = SettingViewController()
                self?.navigationController?.pushViewController(settingVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
        
        self.centerView.collectionView.rx.modelSelected(String.self).subscribe(onNext: { [weak self] title in
            ToastViewConfig.showToast(message: title)
            if IS_LOGIN {
                self?.toPushWithTitle(form: title)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
        
        //跳转订单页面
        self.centerView.orderBtn.rx.tap.subscribe(onNext: { [weak self] in
            if IS_LOGIN {
                let orderListVc = UserAllOrderSController()
                if let model = self?.model {
                    orderListVc.model.accept(model)
                }
                self?.navigationController?.pushViewController(orderListVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
        
        //跳转我的下载
        self.centerView.downloadBtn.rx.tap.subscribe(onNext: { [weak self] in
            if IS_LOGIN {
                let downloadVc = MyDownloadViewController()
                if let model = self?.model {
                    downloadVc.model.accept(model)
                }
                self?.navigationController?.pushViewController(downloadVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
        
        //跳转关注页面
        self.centerView.focusBtn.rx.tap.subscribe(onNext: { [weak self] in
            if IS_LOGIN {
                let focusVc = FocusViewController()
                if let model = self?.model {
                    focusVc.model.accept(model)
                }
                self?.navigationController?.pushViewController(focusVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
        
        //跳转浏览历史
        self.centerView.historyBtn.rx.tap.subscribe(onNext: { [weak self] in
            if IS_LOGIN {
                let historyVc = BrowsingHistoryViewController()
                if let model = self?.model {
                    historyVc.model.accept(model)
                }
                self?.navigationController?.pushViewController(historyVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
        
        self.centerView.ctImageView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            let menVc = MembershipCenterViewController()
            self?.navigationController?.pushViewController(menVc, animated: true)
        }).disposed(by: disposeBag)
        
//
        
        //监控
        self.centerView.jiankongBtn.rx.tap.subscribe(onNext: {
            NotificationCenter.default.post(name: NSNotification.Name(RISK_VC), object: nil)
        }).disposed(by: disposeBag)
        //调查
        self.centerView.tiaochaBtn.rx.tap.subscribe(onNext: {
            NotificationCenter.default.post(name: NSNotification.Name(DILI_VC), object: nil)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if IS_LOGIN {
            //获取套餐信息
            getBuymoreinfo()
            centerView.huiyuanIcon.isHidden = false
        }else {
            centerView.phoneLabel.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.popLogin()
            }).disposed(by: disposeBag)
            centerView.huiyuanIcon.isHidden = true
            self.centerView.modelArray.accept(modelArray2)
        }
    }
}

extension WDCenterViewController {
    
    func getBuymoreinfo() {
        let man = RequestManager()
        let customernumber = UserDefaults.standard.object(forKey: WDY_CUSTOMERNUMBER) as? String ?? ""
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: buymore_info,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.model = model
                    getCenterInfo(model: model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getCenterInfo(model: DataModel) {
        centerView.timeLabel.text = "\(model.endtime ?? "") 到期"
        let accounttype = model.accounttype ?? 0
        let userIdentity = model.userIdentity ?? ""
        let combonumber = model.combonumber ?? 0
        centerView.descLabel.text = "问道云已陪伴您\(combonumber)天"
        let ktImageName: String
        let huiyuanIconName: String
        if userIdentity == "2" {
            ktImageName = "xufeihuiyuanimage"
            huiyuanIconName = (accounttype == 2 || accounttype == 3) ? "VIP_02" : "VIP_01"
        } else if userIdentity == "3" {
            ktImageName = "xufeihuiyuanimage"
            huiyuanIconName = (accounttype == 2 || accounttype == 3) ? "SVIP_02" : "SVIP_01"
        } else {
            ktImageName = "kaitonghuiahun"
            huiyuanIconName = "normalvip"
        }
        centerView.timeLabel.isHidden = userIdentity == "1" ? true : false
        centerView.descLabel2.text = userIdentity == "1" ? "开通VIP 享40项特权" : "已享40+项企业VIP特权权益"
        // 设置图片
        centerView.ktImageView.image = UIImage(named: ktImageName)
        centerView.huiyuanIcon.image = UIImage(named: huiyuanIconName)
        if accounttype != 2  {
            self.centerView.modelArray.accept(modelArray2)
        }else {
            self.centerView.modelArray.accept(modelArray1)
        }
        
    }
    
    //更多功能跳转
    func toPushWithTitle(form title: String) {
        switch title {
        case "发票抬头":
            let addVc = AddInvoiceViewController()
            self.navigationController?.pushViewController(addVc, animated: true)
            break
        case "我要开盘":
            break
        case "客服中心":
            break
        case "微信通知":
            let wechatVc = WechatPushViewController()
            self.navigationController?.pushViewController(wechatVc, animated: true)
            break
        case "邀请好友":
            break
        case "分享好友":
            break
        case "加入分销":
            break
        case "联系我们":
            let conVc = ContactUsViewController()
            self.navigationController?.pushViewController(conVc, animated: true)
            break
        case "意见反馈":
            break
        case "团体中心":
            break
        default:
            break
        }
    }
    
}

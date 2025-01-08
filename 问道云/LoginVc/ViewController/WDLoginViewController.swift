//
//  WDLoginViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import NTESQuickPass

class WDLoginViewController: WDBaseViewController {
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.mimaBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.tapClick()
        }).disposed(by: disposeBag)
        
        //获取验证码
        loginView.sendBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCodeInfo()
        }).disposed(by: disposeBag)
        
        loginView.block1 = { [weak self] in
            self?.pushWebPage(from: agreement_url)
        }
        
        loginView.block2 = { [weak self] in
            self?.pushWebPage(from: privacy_url)
        }
        
        //微信登陆
        loginView.weiBtn.rx.tap.subscribe(onNext: { [weak self] in
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = GetIDFVConfig.getIDFV()
            WXApi.send(req) { result in
                print("微信result:\(result)")
            }
            self?.loginView.phoneTx.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        //一键登录
        loginView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.oneLogin()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginView.phoneTx.becomeFirstResponder()
    }
    
}

extension WDLoginViewController {
    
    func tapClick() {
        //密码登录
        let passwordVc = PasswordLoginViewController()
        passwordVc.phoneStr = self.loginView.phoneTx.text ?? ""
        self.navigationController?.pushViewController(passwordVc, animated: true)
    }
    
    //获取验证码
    func getCodeInfo() {
        let man = RequestManager()
        let dict = ["phone": self.loginView.phoneTx.text ?? ""]
        man.requestAPI(params: dict, pageUrl: get_code, method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                self?.pushCodeVc()
                ToastViewConfig.showToast(message: success.msg ?? "")
                break
            case .failure(_):
                break
            }
        }
    }
    
    func pushCodeVc() {
        let codeVc = GetCodeViewController()
        codeVc.phoneStr = self.loginView.phoneTx.text ?? ""
        self.navigationController?.pushViewController(codeVc, animated: true)
    }
    
}

extension WDLoginViewController {
    
    private func oneLogin() {
        let manager = NTESQuickLoginManager.sharedInstance()
        manager.register(withBusinessID: "5467cd077ec5425c8779ef27b682bb8e")
        //是否支持一键登录
        let isOneLogin = manager.shouldQuickLogin()
        if !isOneLogin {
            ToastViewConfig.showToast(message: "您的设备不支持一键登录功能!")
        }else {
            self.oneTouchLoginInfo(from: manager)
        }
    }
    
    private func oneTouchLoginInfo(from manager: NTESQuickLoginManager) {
        manager.getPhoneNumberCompletion { resultDic in
            if let boolNum = resultDic["success"] as? NSNumber, boolNum.boolValue {
                let securityPhone = resultDic["securityPhone"]
                print("securityPhone====\(securityPhone ?? "")")
            } else {
                // 预取号失败，建议后续直接走降级方案（例如短信）
            }
        }
        
    }
    
}



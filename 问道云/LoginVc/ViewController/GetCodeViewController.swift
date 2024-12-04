//
//  GetCodeViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/4.
//

import UIKit

class GetCodeViewController: WDBaseViewController {
    
    var phoneStr: String = ""
    
    var codeTime = 60
    
    var codeTimer: Timer!
    
    lazy var codeView: CodeView = {
        let codeView = CodeView()
        return codeView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        codeView.pLabel.text = "验证码已发送至+86 \(phoneStr)"
        
        codeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        self.codeView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        self.codeView.resendBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCodeInfo()
        }).disposed(by: disposeBag)
        
        self.codeView.codeBlock = { [weak self] code in
            self?.view.endEditing(true)
            self?.getLoginInfo(from: code)
        }
    }
    

}

extension GetCodeViewController {
    
    
    @objc func updateTime() {
        if codeTime > 0 {
            codeTime -= 1
            self.codeView.resendBtn.setTitle("(\(self.codeTime)s后重新获取)", for: .normal)
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        codeTimer.invalidate()
        self.codeView.resendBtn.isEnabled = true
        self.codeView.resendBtn.setTitle("Resend", for: .normal)
        codeTime = 60
    }
    
    //获取验证码
    func getCodeInfo() {
        let man = RequestManager()
        let dict = ["phone": self.phoneStr]
        man.requestAPI(params: dict, pageUrl: get_code, method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                ToastViewConfig.showToast(message: success.msg ?? "")
                codeView.resendBtn.isEnabled = false
                codeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                break
            case .failure(_):
                break
            }
        }
    }
    
    //验证码登录
    func getLoginInfo(from code: String) {
        let man = RequestManager()
        let dict = ["phone": self.phoneStr, "code": code]
        man.requestAPI(params: dict, pageUrl: get_code_login, method: .post) { result in
            switch result {
            case .success(let success):
                //保存登录信息和跳转到首页
                if let model = success.data {
                    let phone = model.userinfo?.username ?? ""
                    let token = model.access_token ?? ""
                    WDLoginConfig.saveLoginInfo(phone, token)
                }
                NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                break
            case .failure(_):
                break
            }
        }
    }
    
}

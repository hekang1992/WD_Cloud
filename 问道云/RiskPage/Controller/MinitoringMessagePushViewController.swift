//
//  MinitoringMessagePushViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/19.
//  监控消息通知

import UIKit

class MinitoringMessagePushViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "监控动态消息通知"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

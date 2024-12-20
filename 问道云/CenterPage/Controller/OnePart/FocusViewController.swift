//
//  FocusViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  我的关注页面

import UIKit
import RxRelay

class FocusViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "我的关注"
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

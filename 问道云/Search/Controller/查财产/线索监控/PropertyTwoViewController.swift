//
//  PropertyTwoViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import DropMenuBar

class PropertyTwoViewController: WDBaseViewController {
    
    var backBlock: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "财产线索监控"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.backBlock?()
        }).disposed(by: disposeBag)
        
        let oneMenu = MenuAction(title: "财产流向", style: .typeList)!
        let twoMenu = MenuAction(title: "线索类型", style: .typeList)!
        let threeMenu = MenuAction(title: "财产类型", style: .typeList)!
        let fourMenu = MenuAction(title: "更多筛选", style: .typeCustom)!
        let menuView = DropMenuBar(action: [oneMenu, twoMenu, threeMenu, fourMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
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

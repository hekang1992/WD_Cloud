//
//  HighSearchResultViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/3.
//

import UIKit

class HighSearchResultViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "搜索结果"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    //搜索条件
    var searchConditionArray: [String]? {
        didSet {
            guard let searchConditionArray = searchConditionArray else { return }
            numLabel.text = "已选 \(searchConditionArray.count)"
        }
    }
    
    //搜索参数
    var pageIndex: Int = 1
    //关键词
    var keyword: String = ""
    //精准度
    var matchType: String = ""
    //行业
    var industryType: String = ""
    //地区
    var region: String = ""
    //登记状态
    var regStatusVec: [Int] = []
    //成立年限
    var incDateTypeVec: [Int] = []
    //自定义时间
    var incDateRange: String = ""
    //注册资本
    var regCapLevelVec: [Int] = []
    //自定义资本
    var regCapRange: String = ""
    //机构类型
    var econTypeVec: [Int] = []
    //企业类型
    var categoryVec: [Int] = []
    //参保人数
    var sipCountLevelVec: [Int] = []
    //自定义参保人数
    var sipCountRange: String = ""
    //上市状态
    var listStatusVec: [Int] = []
    //上市板块
    var listingSectorVec: [Int] = []
    //邮箱
    var hasEmail: Bool = true
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.textAlignment = .left
        numLabel.font = .mediumFontOfSize(size: 12)
        return numLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.backgroundColor = .white
        view.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(16.5)
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(headView.snp.bottom).offset(13.5)
        }
    }

}

extension HighSearchResultViewController {
    
    
    
}

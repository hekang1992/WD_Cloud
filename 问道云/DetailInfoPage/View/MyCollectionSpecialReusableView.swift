//
//  MyCollectionSpecialReusableView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//  企业详情的自定义头部

import UIKit
import RxSwift
import RxRelay

class MyCollectionSpecialReusableView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    static let identifier = "MyCollectionSpecialReusableView"
    
    lazy var headView: CompanyDetailHeadView = {
        let headView = CompanyDetailHeadView()
        return headView
    }()
    
    //简介
    lazy var infoView: CompanyDescInfoView = {
        let infoView = CompanyDescInfoView()
        return infoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            //icon
            headView.oneHeadView.iconImageView.kf.setImage(with: URL(string: model.firmInfo?.logo ?? ""), placeholder: UIImage.imageOfText(model.firmInfo?.entityName ?? "", size: (40, 40)))
            //名字
            headView.oneHeadView.namelabel.text = model.firmInfo?.entityName ?? ""
            //代码
            headView.oneHeadView.numlabel.text = model.firmInfo?.usCreditCode ?? ""
            //标签
            let riskLabels = model.warnLabels?.compactMap{ $0.name } ?? []
            headView.oneHeadView.tagArray.accept(riskLabels)
            //简介
            let descInfo = model.firmInfo?.businessScope ?? ""
            headView.oneHeadView.desLabel.text = "简介: \(descInfo)"
            infoView.desLabel.text = "简介: \(descInfo)"
            headView.moreBtnBlock = { [weak self] in
                guard let self = self else { return }
                keyWindow?.addSubview(infoView)
                infoView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(self.headView.oneHeadView.desLabel.snp.top)
                }
                UIView.animate(withDuration: 0.25) {
                    self.infoView.alpha = 1
                    self.headView.oneHeadView.desLabel.alpha = 0
                    self.headView.oneHeadView.moreButton.alpha = 0
                }
            }
            infoView.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.infoView.alpha = 0
                        self.headView.oneHeadView.desLabel.alpha = 1
                        self.headView.oneHeadView.moreButton.alpha = 1
                    }
            }).disposed(by: disposeBag)
            //法定代表人
            headView.oneHeadView.nameView.label2.text = model.firmInfo?.legalPerson?.legalName ?? ""
            //注册资本
            let moneyStr = model.firmInfo?.registerCapital ?? ""
            let unit = model.firmInfo?.registerCapitalCurrency ?? ""
            headView.oneHeadView.moneyView.label2.text = moneyStr + unit
            //成立时间
            headView.oneHeadView.timeView.label2.text = model.firmInfo?.incorporationTime ?? ""
            //行业
            headView.oneHeadView.oneView.label2.text = model.firmInfo?.industry?.first ?? ""
            //规模
            headView.oneHeadView.twoView.label2.text = model.firmInfo?.scale ?? "--"
            //员工
            headView.oneHeadView.threeView.timeLabel.text = model.employees?.lastYear ?? ""
            headView.oneHeadView.threeView.label2.text = "\(model.employees?.lastNumber ?? 0)人"
            //利润
            headView.oneHeadView.fourView.timeLabel.text = model.incomeInfo?.lastYear ?? ""
            headView.oneHeadView.fourView.label2.text = String(model.incomeInfo?.lastAmount ?? 0)
            //收入
            headView.oneHeadView.fiveView.timeLabel.text = model.profitInfo?.lastYear ?? ""
            headView.oneHeadView.fiveView.label2.text = String(model.profitInfo?.lastAmount ?? 0)
            
            //主要股东
            headView.threeHeadView.dataModel.accept(model)
            
            //常用服务
            headView.sixHeadView.oneItems = [
                .init(imageResource: "itemoneicon",
                      path: "/business-situation/make-tender"),
                
                .init(imageResource: "itemtwoicon",
                      path: "/litigation-risk/judicial-action"),
                
                .init(imageResource: "itemthreeicon",
                      path: "/basic-information/property-clues"),
                
                .init(imageResource: "itemfouricon",
                      path: ""),
                
                .init(imageResource: "itemfiveicon",
                      path: "")
            ]
            //问道图谱
            headView.sixHeadView.twoItems = [
                .init(imageResource: "picone",
                      path: "/enterprise-chart/enterprise-atlas"),
                
                .init(imageResource: "pictwo",
                      path: "/enterprise-chart/equity-chart"),
                
                .init(imageResource: "picthree",
                      path: "/enterprise-chart/relationship-graph"),
                
                .init(imageResource: "picfouric",
                      path: "/enterprise-chart/actual-controller"),
                
                .init(imageResource: "picfiveicon",
                      path: "/enterprise-chart/beneficiary-person"),
                
                .init(imageResource: "picsixicon",
                      path: "/enterprise-chart/external-investment"),
                
                .init(imageResource: "picsevicon",
                      path: "/enterprise-chart/structure-chart")
            ]
            
            //股票信息
            if let stockInfo = model.stockInfo, !stockInfo.isEmpty {
                headView.stockView.dataModel.accept(model)
                headView.stockView.isHidden = false
            }else {
                headView.stockView.isHidden = true
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

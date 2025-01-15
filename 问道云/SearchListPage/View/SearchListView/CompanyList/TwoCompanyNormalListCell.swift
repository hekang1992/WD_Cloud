//
//  TwoCompanyNormalListCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/10.
//  不带风险扫描的cell

import UIKit
import RxRelay
import TagListView

class TwoCompanyNormalListCell: BaseViewCell {
    
    //地址回调
    var addressBlock: ((pageDataModel) -> Void)?
    //官网回调
    var websiteBlock: ((pageDataModel) -> Void)?
    //电话回调
    var phoneBlock: ((pageDataModel) -> Void)?
    //人物点击
    var peopleBlock: ((pageDataModel) -> Void)?

    var model = BehaviorRelay<pageDataModel?>(value: nil)
    
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    
    var tagArray: [String] = []
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 3
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        return tagListView
    }()
    
    lazy var nameView: BiaoQianView = {
        let nameView = BiaoQianView(frame: .zero, enmu: .hide)
        nameView.label1.text = "法定代表人"
        nameView.lineView.isHidden = false
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.label1.text = "注册资本"
        moneyView.lineView.isHidden = false
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        return timeView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EBEBEB")
        return lineView
    }()
    
    lazy var addressimageView: UIImageView = {
        let addressimageView = UIImageView()
        addressimageView.image = UIImage(named: "adressimageicon")
        addressimageView.contentMode = .scaleAspectFill
        addressimageView.isUserInteractionEnabled = true
        return addressimageView
    }()
    
    lazy var websiteimageView: UIImageView = {
        let websiteimageView = UIImageView()
        websiteimageView.image = UIImage(named: "guanwangimage")
        websiteimageView.contentMode = .scaleAspectFill
        websiteimageView.isUserInteractionEnabled = true
        return websiteimageView
    }()
    
    lazy var phoneimageView: UIImageView = {
        let phoneimageView = UIImageView()
        phoneimageView.image = UIImage(named: "dianhuaimageicon")
        phoneimageView.contentMode = .scaleAspectFill
        phoneimageView.isUserInteractionEnabled = true
        return phoneimageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(nameView)
        contentView.addSubview(moneyView)
        contentView.addSubview(timeView)
        contentView.addSubview(lineView)
        contentView.addSubview(addressimageView)
        contentView.addSubview(websiteimageView)
        contentView.addSubview(phoneimageView)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top).offset(-1)
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(8)
        }
        
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.width.equalTo(SCREEN_WIDTH - 80)
            make.height.equalTo(15)
        }
        
        moneyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.size.equalTo(CGSize(width: 150, height: 36))
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.height.equalTo(36)
        }
        
        timeView.snp.makeConstraints { make in
            make.left.equalTo(moneyView.snp.right)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.height.equalTo(36)
            make.right.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(tagListView.snp.bottom).offset(49.5)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-38)
        }
        
        addressimageView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 47, height: 21))
            make.right.equalToSuperview().offset(-12)
        }
        
        websiteimageView.snp.makeConstraints { make in
            make.top.equalTo(addressimageView.snp.top)
            make.size.equalTo(CGSize(width: 47, height: 21))
            make.right.equalTo(addressimageView.snp.left).offset(-8)
        }
        
        phoneimageView.snp.makeConstraints { make in
            make.top.equalTo(addressimageView.snp.top)
            make.size.equalTo(CGSize(width: 47, height: 21))
            make.right.equalTo(websiteimageView.snp.left).offset(-8)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            self.ctImageView.kf.setImage(with: URL(string: model.firmInfo?.logo ?? ""), placeholder: UIImage.imageOfText(model.firmInfo?.entityName ?? "", size: (32, 32), bgColor: .random(), textColor: .white))
           
            self.nameLabel.attributedText = TextStyler.styledText(for: model.firmInfo?.entityName ?? "", target: model.searchStr ?? "", color: UIColor.init(cssStr: "#F55B5B")!)
            
            self.nameView.label2.text = model.legalPerson?.legalName ?? ""
            self.nameView.label2.textColor = .init(cssStr: "#F55B5B")
           
            self.moneyView.label2.text = "\(model.firmInfo?.registerCapital ?? "--")\(model.firmInfo?.registerCapitalCurrency ?? "")"
            self.moneyView.label2.textColor = .init(cssStr: "#333333")
            
            self.timeView.label2.text = model.firmInfo?.incorporationTime ?? ""
            self.timeView.label2.textColor = .init(cssStr: "#333333")
            
            //小标签
            self.tagArray = model.labels?.compactMap { $0.name ?? "" } ?? []
            setupScrollView(tagScrollView: tagListView, tagArray: tagArray)
            
        }).disposed(by: disposeBag)
        
        //地址点击
        addressimageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            if let self = self, let model = self.model.value {
                self.addressBlock?(model)
            }
        }).disposed(by: disposeBag)
        
        //官网点击
        websiteimageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            if let self = self, let model = self.model.value {
                self.websiteBlock?(model)
            }
        }).disposed(by: disposeBag)
        
        //电话点击
        phoneimageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            if let self = self, let model = self.model.value {
                self.phoneBlock?(model)
            }
        }).disposed(by: disposeBag)
        
        nameView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            if let self = self, let model = self.model.value {
                self.peopleBlock?(model)
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension TwoCompanyNormalListCell {
    
    func setupScrollView(tagScrollView: UIScrollView, tagArray: [String]) {
        // 清理子视图
        for view in tagScrollView.subviews {
            view.removeFromSuperview()
        }
        
        let maxWidth = UIScreen.main.bounds.width - 80 // 标签展示最大宽度（左右各 20 的边距）
        let openButtonWidth: CGFloat = 35 // 展开按钮宽度
        let buttonHeight: CGFloat = 15 // 标签高度
        let buttonSpacing: CGFloat = 2 // 标签之间的间距
        var numberOfLine: CGFloat = 1 // 标签总行数
        var lastRight: CGFloat = 0 // 标签的左边距
        let isOpen = companyModel.isOpenTag // 标签展开或者收起
        
        // 创建展开/收起按钮
        let openButton = UIButton(type: .custom)
        openButton.titleLabel?.font = .regularFontOfSize(size: 10)
        openButton.backgroundColor = UIColor(cssStr: "#3F96FF")?.withAlphaComponent(0.1)
        openButton.setTitle("展开", for: .normal)
        openButton.setTitleColor(UIColor(cssStr: "#3F96FF"), for: .normal)
        openButton.layer.masksToBounds = true
        openButton.layer.cornerRadius = 2
        openButton.setImage(UIImage(named: "xialaimageicon"), for: .normal)
        openButton.addTarget(self, action: #selector(didOpenTags), for: .touchUpInside)
        if isOpen {
            openButton.setTitle("收起", for: .normal)
            openButton.setImage(UIImage(named: "shangimageicon"), for: .normal)
        }
        
        // 计算标签总长度
        var totalLength = lastRight
        for tags in tagArray {
            let tag = "\(tags)   "
            let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.regularFontOfSize(size: 11)])
            var width = titleSize.width
            if tags.contains("展开") {
                width = openButtonWidth
            }
            totalLength += buttonSpacing + width
        }
        
        // 判断标签长度是否超过一行
        var tagArrayToShow = [String]()
        if totalLength - buttonSpacing > maxWidth { // 整体超过一行，添加展开收起
            var p = 0
            var lastLength = lastRight
            for tags in tagArray {
                let tag = "\(tags)   "
                let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.regularFontOfSize(size: 11)])
                var width = titleSize.width
                if tags.contains("展开") {
                    width = openButtonWidth
                }
                if (lastLength + openButtonWidth < maxWidth) && (lastLength + buttonSpacing + width + openButtonWidth > maxWidth) {
                    break
                }
                lastLength += buttonSpacing + width
                p += 1
            }
            
            if !isOpen && p != 0 { // 收起状态
                for i in 0..<p {
                    tagArrayToShow.append(tagArray[i])
                }
                tagArrayToShow.append("展开")
            } else if isOpen {
                tagArrayToShow.append(contentsOf: tagArray)
                tagArrayToShow.append("收起")
            } else {
                tagArrayToShow.append(contentsOf: tagArray)
            }
        } else {
            tagArrayToShow.append(contentsOf: tagArray)
        }
        
        // 插入标签和展开按钮
        for tags in tagArrayToShow {
            if tags == "展开" || tags == "收起" {
                // 检查当前行剩余宽度是否足够放下收起按钮
                if lastRight + openButtonWidth > maxWidth {
                    // 另起一行
                    numberOfLine += 1
                    lastRight = 0
                }
                
                tagScrollView.addSubview(openButton)
                openButton.snp.remakeConstraints { make in
                    make.left.equalTo(lastRight)
                    make.top.equalTo((numberOfLine - 1) * (buttonHeight + buttonSpacing))
                    make.height.equalTo(buttonHeight)
                    make.width.equalTo(openButtonWidth)
                }
                lastRight += openButtonWidth + buttonSpacing
            } else {
                let lab = UILabel()
                lab.font = .regularFontOfSize(size: 11)
                lab.textColor = UIColor(cssStr: "#ECF2FF")
                lab.backgroundColor = UIColor(cssStr: "#93B2F5")
                lab.layer.masksToBounds = true
                lab.layer.cornerRadius = 2
                lab.textAlignment = .center
                lab.text = "\(tags)   "
                self.nameLabelColor(from: lab)
                tagScrollView.addSubview(lab)
                
                let titleSize = (lab.text! as NSString).size(withAttributes: [.font: lab.font!])
                let width = titleSize.width  // 增加左右 padding
                
                if width + lastRight > maxWidth {
                    numberOfLine += 1
                    lastRight = 0
                }
                
                lab.snp.remakeConstraints { make in
                    make.left.equalTo(lastRight)
                    make.top.equalTo((numberOfLine - 1) * (buttonHeight + buttonSpacing))
                    make.height.equalTo(buttonHeight)
                    make.width.equalTo(width)
                }
            
                lastRight += width + buttonSpacing
            }
        }
        
        // 设置 tagScrollView 的约束
        tagScrollView.snp.updateConstraints { make in
            make.height.equalTo(numberOfLine * (buttonHeight + buttonSpacing))
        }
        self.lineView.snp.updateConstraints { make in
            make.top.equalTo(tagListView.snp.bottom).offset(60)
        }
        openButton.layoutButtonEdgeInsets(style: .right, space: 2)
    }
    
    // 按钮点击事件
    @objc func didOpenTags(_ sender: UIButton) {
        companyModel.isOpenTag.toggle() // 切换展开/收起状态
        setupScrollView(tagScrollView: tagListView, tagArray: tagArray) // 重新设置标签
    }

    func nameLabelColor(from tagView: UILabel) {
        let currentTitle = tagView.text ?? ""
        if currentTitle.contains("经营异常") || currentTitle.contains("被执行人") || currentTitle.contains("失信被执行人") || currentTitle.contains("限制高消费") || currentTitle.contains("票据违约") || currentTitle.contains("债券违约") {
            tagView.backgroundColor = .init(cssStr: "#F55B5B")?.withAlphaComponent(0.1)
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }else if currentTitle.contains("存续") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#4DC929")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("注销") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#FF7D00")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("吊销")  {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("小微企业") || currentTitle.contains("高新技术企业") || currentTitle.contains("国有控股") || currentTitle.contains("国有独资") || currentTitle.contains("国有全资") || currentTitle.contains("深主板") || currentTitle.contains("沪主板") || currentTitle.contains("港交所") || currentTitle.contains("北交所") || currentTitle.contains("发债"){
            tagView.backgroundColor = .init(cssStr: "#3F96FF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#3F96FF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        } else {
            tagView.backgroundColor = .init(cssStr: "#3F96FF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#3F96FF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }
    
    }
}

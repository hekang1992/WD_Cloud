//
//  SearchMonitoringViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/6.
//  搜索监控列表cell

import UIKit

class SearchMonitoringViewCell: BaseViewCell {
    
    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            ctImageView.image = UIImage.imageOfText(model.entity_name ?? "", size: (24, 24), cornerRadius: 2)
            namelabel.text = model.entity_name ?? ""
            configure(with: model)
        }
    }
        
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        namelabel.numberOfLines = 0
        return namelabel
    }()
    
    lazy var menuBtn: UIButton = {
        let menuBtn = UIButton(type: .custom)
        menuBtn.setTitle("自身企业", for: .normal)
        menuBtn.layer.cornerRadius = 3.5
        menuBtn.layer.borderWidth = 1
        menuBtn.setImage(UIImage(named: "xialaimageicon"), for: .normal)
        menuBtn.titleLabel?.font = .regularFontOfSize(size: 11)
        menuBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        menuBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        menuBtn.backgroundColor = .white
        return menuBtn
    }()
    
    lazy var addBtn: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "jiankonganniu"), for: .normal)
        return addBtn
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var oneListView: AddMonitoringListView = {
        let oneListView = AddMonitoringListView()
        oneListView.titleLabel.text = "企业受益人/实控人/大股东/董监高/法人"
        return oneListView
    }()
    
    lazy var twoListView: AddMonitoringListView = {
        let twoListView = AddMonitoringListView()
        twoListView.titleLabel.text = "企业高管"
        return twoListView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(menuBtn)
        contentView.addSubview(addBtn)
        contentView.addSubview(stackView)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.right.equalToSuperview().offset(-105)
        }
        addBtn.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.size.equalTo(CGSize(width: 30, height: 18))
            make.right.equalToSuperview().offset(-14)
        }
        menuBtn.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.size.equalTo(CGSize(width: 62, height: 18))
            make.right.equalTo(addBtn.snp.left).offset(-5)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom).offset(8)
            make.left.equalTo(namelabel.snp.left)
            make.right.equalTo(addBtn.snp.right)
            make.bottom.equalTo(-10).priority(.medium)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SearchMonitoringViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        menuBtn.layoutButtonEdgeInsets(style: .right, space: 2)
    }
    
    func configure(with model: itemsModel) {
        //企业法人
        let seniorexecutiveArray = model.seniorexecutive ?? []
        //企业高管
        let personnelArray = model.personnel ?? []
        
        if !seniorexecutiveArray.isEmpty {
            oneListView.modelArray = seniorexecutiveArray
            stackView.addArrangedSubview(oneListView)
        } else {
            oneListView.removeFromSuperview()
        }
        if !personnelArray.isEmpty {
            twoListView.modelArray = personnelArray
            stackView.addArrangedSubview(twoListView)
        } else {
            twoListView.removeFromSuperview()
        }
    }
    
}

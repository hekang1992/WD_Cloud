//
//  TwoCompanyView.swift
//  问道云
//
//  Created by Andrew on 2025/1/9.
//  企业搜索列表

import UIKit
import RxRelay

class TwoCompanyView: BaseView {
    
    //地址回调
    var addressBlock: ((pageDataModel) -> Void)?
    //官网回调
    var websiteBlock: ((pageDataModel) -> Void)?
    //电话回调
    var phoneBlock: ((pageDataModel) -> Void)?
    //人物回调
    var peopleBlock: ((pageDataModel) -> Void)?
    //企业ID回调
    var entityIdBlock: ((String, String) -> Void)?
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var dataModelArray = BehaviorRelay<[pageDataModel]?>(value: nil)
    
    //被搜索的文字,根据这个文字,去给cell的namelabel加上颜色
    var searchWordsRelay = BehaviorRelay<String?>(value: nil)
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        return whiteView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.font = .mediumFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var pageLabel: UILabel = {
        let pageLabel = UILabel()
        pageLabel.font = .mediumFontOfSize(size: 12)
        pageLabel.textColor = .init(cssStr: "#666666")
        pageLabel.textAlignment = .right
        return pageLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        //头部人员cell
        tableView.register(TwoCompanyHeadPeopleCell.self, forCellReuseIdentifier: "TwoCompanyHeadPeopleCell")
        //公司cell
        tableView.register(TwoCompanySpecListCell.self, forCellReuseIdentifier: "TwoCompanySpecListCell")
        tableView.register(TwoCompanyNormalListCell.self, forCellReuseIdentifier: "TwoCompanyNormalListCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(tableView)
        whiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TwoCompanyView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let model = dataModel.value
        let bossList = model?.bossList ?? []
        if !bossList.isEmpty {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataModel.value
        let bossList = model?.bossList ?? []
        if !bossList.isEmpty {
            if section == 0 {
                return bossList.count
            }else {
                return dataModelArray.value?.count ?? 0
            }
        }else {
            return dataModelArray.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataModel.value
        let bossList = model?.bossList ?? []
        
        let companyList = dataModelArray.value
        let pageDataModel = companyList?[indexPath.row]
        if let riskModel = pageDataModel?.riskInfo, let content = riskModel.content, !content.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanySpecListCell") as? TwoCompanySpecListCell
            pageDataModel?.searchStr = self.searchWordsRelay.value ?? ""
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.model.accept(pageDataModel)
            cell?.addressBlock = { [weak self] model in
                self?.addressBlock?(model)
            }
            cell?.websiteBlock = { [weak self] model in
                self?.websiteBlock?(model)
            }
            cell?.phoneBlock = { [weak self] model in
                self?.phoneBlock?(model)
            }
            cell?.peopleBlock = { [weak self] model in
                self?.peopleBlock?(model)
            }
            cell?.focusBlock = { [weak self] model in
                if let cell = cell {
                    self?.focusInfo(from: model, cell: cell)
                }
            }
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanyNormalListCell") as? TwoCompanyNormalListCell
            pageDataModel?.searchStr = self.searchWordsRelay.value ?? ""
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.model.accept(pageDataModel)
            cell?.addressBlock = { [weak self] model in
                self?.addressBlock?(model)
            }
            cell?.websiteBlock = { [weak self] model in
                self?.websiteBlock?(model)
            }
            cell?.phoneBlock = { [weak self] model in
                self?.phoneBlock?(model)
            }
            cell?.peopleBlock = { [weak self] model in
                self?.peopleBlock?(model)
            }
            cell?.focusBlock = { [weak self] model in
                if let cell = cell {
                    self?.focusInfo(from: model, cell: cell)
                }
            }
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let countModel = dataModel.value?.pageMeta
        let numStr = countModel?.totalNum ?? 0
        let num = String(countModel?.totalNum ?? 0)
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        //搜索的总结果
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: num, fullText: "搜索到\(num)条结果", font: .mediumFontOfSize(size: 12))
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(10)
        }
        
        //搜到共多少页
        let result = Int(ceil(Double(numStr) / Double(20)))
        headView.addSubview(pageLabel)
        pageLabel.text = "第\(countModel?.index ?? 0)/\(result)页"
        pageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-10)
        }
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.dataModelArray.value?[indexPath.row] {
            print("公司ID=========\(model.firmInfo?.entityId ?? "")")
            self.entityIdBlock?(model.firmInfo?.entityId ?? "", model.firmInfo?.entityName ?? "")
        }
        
    }
    
}

extension TwoCompanyView {
    
    private func focusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        if let specificCell = cell as? TwoCompanyNormalListCell {
            let followStatus = model.followStatus ?? ""
            if followStatus == "1" {
                addFocusInfo(from: model, cell: cell)
            }else {
                deleteFocusInfo(from: model, cell: cell)
            }
        } else if let otherCell = cell as? TwoCompanySpecListCell {
            let followStatus = model.followStatus ?? ""
            if followStatus == "1" {
                addFocusInfo(from: model, cell: cell)
            }else {
                deleteFocusInfo(from: model, cell: cell)
            }
        }
    }
    
    private func addFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["entityId": model.firmInfo?.entityId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/save",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = "2"
                    if let specificCell = cell as? TwoCompanyNormalListCell {
                        specificCell.focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    }else if let otherCell = cell as? TwoCompanySpecListCell {
                        otherCell.focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    }
                    ToastViewConfig.showToast(message: "关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func deleteFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        let man = RequestManager()
        ViewHud.addLoadView()
        var dataIds = [model.firmInfo?.entityId ?? ""]
        let dict = ["ids": dataIds,
                    "followTargetType": "1"] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/batchCancel",
                       method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = "1"
                    if let specificCell = cell as? TwoCompanyNormalListCell {
                        specificCell.focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    }else if let otherCell = cell as? TwoCompanySpecListCell {
                        otherCell.focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    }
                    ToastViewConfig.showToast(message: "取消关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
}

//
//  SearchDondDefaultViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//

import UIKit
import HGSegmentedPageViewController
import RxRelay
import RxSwift
import SwiftyJSON

class SearchDondDefaultViewController: WDBaseViewController {
    
    //参数
    var searchKey = BehaviorRelay<String>(value: "")

    //热搜
    var hotWordsArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    lazy var oneView: OneCompanyView = {
        let oneView = OneCompanyView()
        return oneView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "债券违约"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入法院、公告名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var segmentedPageViewController: HGSegmentedPageViewController = {
        let segmentedPageViewController = HGSegmentedPageViewController()
        segmentedPageViewController.categoryView.alignment = .center
        segmentedPageViewController.categoryView.itemSpacing = 25
        segmentedPageViewController.categoryView.topBorder.isHidden = true
        segmentedPageViewController.categoryView.itemWidth = SCREEN_WIDTH * 0.25
        segmentedPageViewController.categoryView.vernierWidth = 15
        segmentedPageViewController.categoryView.titleNomalFont = .mediumFontOfSize(size: 14)
        segmentedPageViewController.categoryView.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmentedPageViewController.categoryView.titleNormalColor = .init(cssStr: "#9FA4AD")
        segmentedPageViewController.categoryView.titleSelectedColor = .init(cssStr: "#333333")
        segmentedPageViewController.categoryView.vernier.backgroundColor = .init(cssStr: "#547AFF")
        segmentedPageViewController.delegate = self
        return segmentedPageViewController
    }()
    
    lazy var companyVc: SearchCompanyDondDefaultViewController = {
        let companyVc = SearchCompanyDondDefaultViewController()
        return companyVc
    }()
    
    lazy var peopleVc: SearchPeopleDondDefaultViewController = {
        let peopleVc = SearchPeopleDondDefaultViewController()
        return peopleVc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        //设置
        addSegmentedPageViewController()
        setupPageViewControllers()
        //oneview
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }
        
        //删除最近搜索
        self.oneView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
            }).disposed(by: disposeBag)
        
        //删除浏览历史
        self.oneView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
            }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.oneView.lastSearchTextBlock = { [weak self] keywords in
            self?.searchView.searchTx.text = keywords
            self?.searchKey.accept(keywords)
            if keywords.isEmpty {
                self?.oneView.isHidden = false
                //最近搜索
                self?.getlastSearch()
                //浏览历史
                self?.getBrowsingHistory()
                //热搜
                self?.getHotWords()
            }else {
                self?.oneView.isHidden = true
            }
        }
        
        //搜索
        self.searchView.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchView.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                if keywords.isEmpty {
                    self?.oneView.isHidden = false
                    //最近搜索
                    self?.getlastSearch()
                    //浏览历史
                    self?.getBrowsingHistory()
                    //热搜
                    self?.getHotWords()
                }else {
                    self?.oneView.isHidden = true
                }
                self?.searchKey.accept(keywords)
            }).disposed(by: disposeBag)
    
        //获取城市数据
        getAllRegionInfo()
        //最近搜索
        self.getlastSearch()
        //浏览历史
        self.getBrowsingHistory()
        //热搜
        self.getHotWords()
    }
    
    //获取所有城市数据
    func getAllRegionInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let emptyDict = [String: Any]()
        man.requestAPI(params: emptyDict,
                       pageUrl: "/operation/ajax/areaTree",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let modelArray = success.data?.data {
                    self.regionModelArray.accept(modelArray)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchDondDefaultViewController: HGSegmentedPageViewControllerDelegate {
    
    private func addSegmentedPageViewController() {
        self.addChild(self.segmentedPageViewController)
        self.view.addSubview(self.segmentedPageViewController.view)
        self.segmentedPageViewController.didMove(toParent: self)
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }
    }
    
    private func setupPageViewControllers() {
        let titles: [String] = ["企业", "人员"]
        segmentedPageViewController.pageViewControllers = [companyVc, peopleVc]
        segmentedPageViewController.selectedPage = 0
        self.segmentedPageViewController.categoryView.titles = titles
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }
    }
    
    func segmentedPageViewControllerWillTransition(toPage page: Int) {
        self.searchKey.asObservable()
            .subscribe(onNext: { [weak self] keyWords in
            guard let self = self else { return }
            if page == 1 {
                peopleVc.keyWords.accept(keyWords)
            }else {
                companyVc.keyWords.accept(keyWords)
            }
        }).disposed(by: disposeBag)
        
        self.regionModelArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            if page == 1 {
                peopleVc.regionModelArray.accept(modelArray)
            }else {
                companyVc.regionModelArray.accept(modelArray)
            }
        }).disposed(by: disposeBag)
        
    }
    
    //最近搜索
    private func getlastSearch() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["searchType": "",
                    "moduleId": "21"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/searchRecord/query",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data {
                    reloadSearchUI(data: rows)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.oneView.searchView.tagListView.removeAllTags()
            self.oneView.searchView.tagListView.addTags(strArray)
            self.oneView.searchView.isHidden = false
            self.oneView.layoutIfNeeded()
            let height = self.oneView.searchView.tagListView.frame.height
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.oneView.searchView.isHidden = true
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "viewrecordtype": "",
                    "moduleId": "21",
                    "pageNum": 1,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows {
                    readHistoryUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let type = model.viewrecordtype ?? ""
                if type == "1" {//企业
                    let entityId = model.firmnumber ?? ""
                    let json: JSON = ["entityId": entityId]
                    let itemModel: itemsModel = itemsModel(json: json)
                    let detailVc = SearchCompanyDeadbeatDetailViewController()
                    detailVc.model = itemModel
                    detailVc.nameTitle = "债券违约记录列表"
                    detailVc.pageUrl = "/riskmonitor/illegalPunish/getBondDefaultDetail"
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }else {//个人
                    let personId = model.personnumber ?? ""
                    let json: JSON = ["personId": personId]
                    let itemModel: itemsModel = itemsModel(json: json)
                    let detailVc = SearchPeopleDeadbeatDetailViewController()
                    detailVc.model = itemModel
                    detailVc.nameTitle = "债券违约记录列表"
                    detailVc.pageUrl = "/riskmonitor/illegalPunish/getBondDefaultDetail"
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }
            }
            let type = model.viewrecordtype ?? ""
            if type == "1" {
                listView.nameLabel.text = model.firmname ?? ""
            }else {
                listView.nameLabel.text = model.personname ?? ""
            }
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
            self.oneView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.oneView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["moduleId": "21"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.hotWordsArray.accept(model.data ?? [])
                    hotsWordsUI(data: model.data ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let type = model.viewrecordtype ?? ""
                if type == "1" {//企业
                    let entityId = model.firmnumber ?? ""
                    let json: JSON = ["entityId": entityId]
                    let itemModel: itemsModel = itemsModel(json: json)
                    let detailVc = SearchCompanyDeadbeatDetailViewController()
                    detailVc.model = itemModel
                    detailVc.nameTitle = "债券违约记录列表"
                    detailVc.pageUrl = "/riskmonitor/illegalPunish/getBondDefaultDetail"
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }else {//个人
                    let personId = model.personnumber ?? ""
                    let json: JSON = ["personId": personId]
                    let itemModel: itemsModel = itemsModel(json: json)
                    let detailVc = SearchPeopleDeadbeatDetailViewController()
                    detailVc.model = itemModel
                    detailVc.nameTitle = "债券违约记录列表"
                    detailVc.pageUrl = "/riskmonitor/illegalPunish/getBondDefaultDetail"
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
            self.oneView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.oneView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            ViewHud.addLoadView()
            let dict = ["searchType": "",
                        "moduleId": "21"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/searchRecord/clear",
                           method: .post) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.oneView.searchView.isHidden = true
                        self.oneView.searchView.snp.updateConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //删除浏览历史
    private func deleteHistoryInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除浏览历史?", confirmAction: {
            let man = RequestManager()
            ViewHud.addLoadView()
            let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["customernumber": customernumber,
                        "moduleId": "21",
                        "viewrecordtype": ""]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord",
                           method: .get) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.oneView.historyView.isHidden = true
                        self.oneView.historyView.snp.updateConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }

}

//
//  DailyReportViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/7.
//  日报

import UIKit
import JXPagingView
import JXSegmentedView

class DailyReportViewController: WDBaseViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var companyVc: DailyCompanyViewController = {
        let companyVc = DailyCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: DailyReportViewController = {
        let peopleVc = DailyReportViewController()
        return peopleVc
    }()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    var JXTableHeaderViewHeight: Int = 0
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var titles: [String] = ["企业", "个人"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#3849F7")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#333333")!.withAlphaComponent(0.6)
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.dataSource = segmentedViewDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.init(cssStr: "#3849F7")!
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 2
        indicator.indicatorWidth = 15
        segmentedView.indicators = [indicator]
        
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        segmentedView.listContainer = pagingView.listContainerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //获取数字信息
        getNumInfo()
    }
    
}

extension DailyReportViewController {
    
    private func getNumInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitortarget/queryRiskMonitorEntity",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data {
                        let titles = ["企业\(model.orgNum ?? 0)", "人员\(model.personNum ?? 0)"]
                        segmentedViewDataSource.titles = titles
                        segmentedView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension DailyReportViewController: JXPagingViewDelegate {
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let headView = UIView()
        return headView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            let companyVc = DailyCompanyViewController()
            return companyVc
        }else {
            let peopleVc = DailyPeopleViewController()
            return peopleVc
        }
    }
    
}

extension DailyReportViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return self.view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}

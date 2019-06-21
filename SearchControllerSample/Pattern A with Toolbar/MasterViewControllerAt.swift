//
//  MasterViewControllerAt.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2019/06/21.
//

import UIKit

class MasterViewControllerAt: UITableViewController {
    
    // データを定義
    let data: [String] = ["This is a testString",
                          "Please add your sentence.",
                          "I like Apple",
                          "Do you like an apple?",
                          "今日はいい天気ですね",
                          "はい、いい 天気です",
                          "私はAppleが好きです",
                          "私はリンゴが嫌いです",
                          "Apple社の天気は雷",
                          "Apple社の天気は雷?"]
    
    // UISearchControllerの変数を作成
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MasterA toolbar"
        
        if #available(iOS 11.0, *){
            // Titleがでかく表示されるやつ．デフォルトはfalseらしい
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // セルの名前を設定
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 検索に関する設定
        let resultController = SearchResultViewControllerAt()
        resultController.navigationDelegate = self  // SearchResultViewControllerからのnavigation遷移をキャッチする
        self.searchController = UISearchController(searchResultsController: resultController)  // 検索結果を表示するViewを設定
        self.searchController.searchResultsUpdater = resultController  // 検索されると動くViewを設定
//        self.searchController.delegate = self  // 検索時だけToolbarを出したい時とか
        self.searchController.hidesNavigationBarDuringPresentation = true  // 検索バーを押したらナビゲーションバーが隠れる
        self.searchController.dimsBackgroundDuringPresentation = true  // 検索中は後ろが暗くなる。
        self.definesPresentationContext = true
        let searchBar = self.searchController.searchBar  // searchBarを取得
        searchBar.delegate = resultController
        searchBar.placeholder = "空白区切りで検索"  // placeholderを設定
        searchBar.scopeButtonTitles = ["どれか含む", "全て含む"]  // Scopeボタンのタイトルを設定
        searchBar.searchBarStyle = .default  // なくてもいい
        searchBar.barStyle = .default  // なくてもいい
        if #available(iOS 11.0, *){
            // iOS11以降は，UINavigationItemにSearchControllerを設定
            self.navigationItem.searchController = self.searchController
            
            // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
            // falseだとスクロール位置に関係なく常にSearchBarが表示される
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }else{
            // iOS11より前は，tableHeaderViewにsearchBarを設定
            self.tableView.tableHeaderView = searchBar  // TableViewの一番上にsearchBarを設置
        }
        
        // ForceTouch
        if #available(iOS 9.0, *){
            resultController.forceTouch = self.traitCollection.forceTouchCapability
            if self.traitCollection.forceTouchCapability == .available{
                self.registerForPreviewing(with: self, sourceView: self.view)
            }
        }
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // セルに表示するテキストを設定
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        DetailView.text = data[indexPath.row]
        DetailView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(DetailView, animated: true)
    }
    
}

// MARK: -

extension MasterViewControllerAt: NavigateFromSearchResultProtocol{
    
    func navigationControllerPush(fromSearchResult viewController: DetailViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func previewingContext(fromSearchResult previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if #available(iOS 9.0, *) {
            self.previewingContext(previewingContext, commit: viewControllerToCommit)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

// MARK: -

@available(iOS 9.0, *)
extension MasterViewControllerAt: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("peek")
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}

/*
// MARK: -

// 検索時だけToolbarを出したい時とか
extension MasterViewControllerAt: UISearchControllerDelegate{
    func willPresentSearchController(_ searchController: UISearchController) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}
*/

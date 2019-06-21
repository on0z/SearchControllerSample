//
//  MasterViewControllerC.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2019/06/21.
//

import UIKit

class MasterViewControllerC: UITableViewController {

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
    // 検索にひっかっかったものを入れる変数
    var filteredItems: [String] = []
    
    // UISearchControllerの変数を作成
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MasterC"
        
        if #available(iOS 11.0, *){
            // Titleがでかく表示されるやつ．デフォルトはfalseらしい
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // セルの名前を設定
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 検索に関する設定
        self.searchController = UISearchController(searchResultsController: nil)  // 検索結果を表示するViewControllerが自分なら，nilを設定
        self.searchController.searchResultsUpdater = self  // 検索されると動くViewを設定
        self.searchController.hidesNavigationBarDuringPresentation = true  // 検索バーを押したらナビゲーションバーが隠れる
        self.searchController.dimsBackgroundDuringPresentation = false  // 検索中は後ろが暗くなる。
        self.definesPresentationContext = true
        let searchBar = self.searchController.searchBar  // searchBarを取得
        searchBar.delegate = self
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
            if self.traitCollection.forceTouchCapability == .available{
                self.registerForPreviewing(with: self, sourceView: self.view)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive{
            return self.filteredItems.count
        }else{
            return self.data.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if self.searchController.isActive{
            cell.textLabel?.text = self.filteredItems[indexPath.row]
        }else{
        // セルに表示するテキストを設定
            cell.textLabel?.text = self.data[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        if self.searchController.isActive{
            DetailView.text = self.filteredItems[indexPath.row]
        }else{
            DetailView.text = self.data[indexPath.row]
        }
        self.navigationController?.pushViewController(DetailView, animated: true)
    }
    
}

// MARK: -

extension MasterViewControllerC: UISearchResultsUpdating{
    
    // 検索された時に実行される関数
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{ return }
        if searchController.searchBar.selectedScopeButtonIndex == 0{ //  or
            self.filteredItems = self.data.filter{
                for word in text.components(separatedBy: " "){
                    if $0.localizedCaseInsensitiveContains(word){
                        return true
                    }
                }
                return false
            }
        }else if searchController.searchBar.selectedScopeButtonIndex == 1{  // and
            self.filteredItems = self.data.filter{
                for word in text.components(separatedBy: " "){
                    if word == ""{
                        continue
                    }
                    if !$0.localizedCaseInsensitiveContains(word){
                        return false
                    }
                }
                return true
            }
        }
        self.tableView.reloadData()
    }
    
}

// MARK: -

extension MasterViewControllerC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.updateSearchResults(for: self.searchController)
    }
    
}

// MARK: -

@available(iOS 9.0, *)
extension MasterViewControllerC: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("peek")
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}

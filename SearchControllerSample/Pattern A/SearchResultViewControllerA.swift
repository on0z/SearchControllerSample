//
//  SearchResultViewControllerA.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2016/08/03.
//

import UIKit

class SearchResultViewControllerA: UITableViewController{
    
    // 検索にひっかっかったものを入れる変数
    var filteredItems: [String] = []
    // MasterTableViewControllerにnavigationをお願いするdelegate
    weak var navigationDelegate: NavigateFromSearchResultProtocol?
    // MasterTableViewControllerからもらう，3Dタッチのステータス
    var forceTouch: UIForceTouchCapability = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セルの名前を設定
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if #available(iOS 9.0, *){
            if forceTouch == .available{
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
        return self.filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // セルに表示するテキストを設定
        cell.textLabel?.text = self.filteredItems[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        DetailView.text = self.filteredItems[indexPath.row]
        self.navigationDelegate?.navigationControllerPush(fromSearchResult: DetailView)
    }
    
}

// MARK: -

extension SearchResultViewControllerA: UISearchResultsUpdating{
    
    // 検索された時に実行される関数
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{ return }
        if searchController.searchBar.selectedScopeButtonIndex == 0{ //  or
            // 正直，ここで`MasterViewControllerA().data.filter`とするのはバッドエクスペリエンス．
            // 実際にはちゃんとした検索関数を作ってください．
            self.filteredItems = MasterViewControllerA().data.filter{
                for word in text.components(separatedBy: " "){
                    if $0.localizedCaseInsensitiveContains(word){
                        return true
                    }
                }
                return false
            }
        }else if searchController.searchBar.selectedScopeButtonIndex == 1{  // and
            // 正直，ここで`MasterViewControllerA().data.filter`とするのはバッドエクスペリエンス．
            // 実際にはちゃんとした検索関数を作ってください．
            self.filteredItems = MasterViewControllerA().data.filter{
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
        tableView.reloadData()
    }
    
}

// MARK: -

extension SearchResultViewControllerA: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchBar.text else{ return }
        if selectedScope == 0{  // or
            // 正直，ここで`MasterViewControllerA().data.filter`とするのはバッドエクスペリエンス．
            // 実際にはちゃんとした検索関数を作ってください．
            self.filteredItems = MasterViewControllerA().data.filter{
                for word in text.components(separatedBy: " "){
                    if $0.localizedCaseInsensitiveContains(word){
                        return true
                    }
                }
                return false
            }
        }else if selectedScope == 1{  // and
            // 正直，ここで`MasterViewControllerA().data.filter`とするのはバッドエクスペリエンス．
            // 実際にはちゃんとした検索関数を作ってください．
            self.filteredItems = MasterViewControllerA().data.filter{
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
        tableView.reloadData()
    }
    
}

// MARK: -

@available(iOS 9.0, *)
extension SearchResultViewControllerA: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("peek")
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationDelegate?.previewingContext(fromSearchResult: previewingContext, commit: viewControllerToCommit)
    }
}

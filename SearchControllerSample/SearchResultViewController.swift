//
//  SearchResultViewController.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2016/08/03.
//

import UIKit

class SearchResultViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    //検索にひっかっかったものを入れる変数
    var filteredItems: [String] = []
    var delegate: SelectedCellProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //セルの名前を設定
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchBar.text else{ return }
        if selectedScope == 0{//or
            filteredItems = MasterViewController().data.filter{
                for word in text.components(separatedBy: " "){
                    if $0.localizedCaseInsensitiveContains(word){
                        return true
                    }
                }
                return false
            }
        }else if selectedScope == 1{//and
            filteredItems = MasterViewController().data.filter{
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //セルに表示するテキストを設定
        cell.textLabel?.text = filteredItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        DetailView.text = self.filteredItems[indexPath.row]
        self.delegate?.didSelectedCell(view: DetailView)
    }
    
    //検索された時に実行される関数
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{ return }
        if searchController.searchBar.selectedScopeButtonIndex == 0{//or
            filteredItems = MasterViewController().data.filter{
                for word in text.components(separatedBy: " "){
                    if $0.localizedCaseInsensitiveContains(word){
                        return true
                    }
                }
                return false
            }
        }else if searchController.searchBar.selectedScopeButtonIndex == 1{//and
            filteredItems = MasterViewController().data.filter{
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

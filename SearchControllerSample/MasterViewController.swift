//
//  MasterViewController.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2016/08/03.
//

import UIKit

class MasterViewController: UITableViewController, SelectedCellProtocol {
    
    //データを定義
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
    
    //UISearchControllerの変数を作成
    var mySearchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Master"
        
        //セルの名前を設定
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //検索に関する設定
        let resultController = SearchResultViewController()
        resultController.delegate = self
        mySearchController = UISearchController(searchResultsController: resultController) //検索結果を表示するViewを設定
        mySearchController.hidesNavigationBarDuringPresentation = true//検索バーを押したらナビゲーションバーが隠れる
        mySearchController.dimsBackgroundDuringPresentation = true//検索中は後ろが暗くなる。
        self.definesPresentationContext = true
        let searchBar = mySearchController.searchBar
        searchBar.delegate = resultController
        searchBar.placeholder = "空白区切りで検索" //placeholderを設定
        searchBar.scopeButtonTitles = ["どれか含む", "全て含む"] //Scopeボタンのタイトルを設定
        searchBar.searchBarStyle = .default //なくてもいい
        searchBar.barStyle = .default //なくてもいい
        self.tableView.tableHeaderView = searchBar //TableViewの一番上にsearchBarを設置
        searchBar.sizeToFit()
        mySearchController.searchResultsUpdater = resultController //検索されると動くViewを設定
        
        //ForceTouch
        if #available(iOS 9.0, *){
            resultController.forceTouch = self.traitCollection.forceTouchCapability
            if self.traitCollection.forceTouchCapability == .available{
                self.registerForPreviewing(with: self, sourceView: self.view)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didSelectedCell(view: DetailViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func didPopCell(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if #available(iOS 9.0, *) {
            self.previewingContext(previewingContext, commit: viewControllerToCommit)
        } else {
            // Fallback on earlier versions
        }
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
        
        //セルに表示するテキストを設定
        cell.textLabel?.text = data[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        DetailView.text = data[indexPath.row]
        self.navigationController?.pushViewController(DetailView, animated: true)
    }
}

@available(iOS 9.0, *)
extension MasterViewController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("peek")
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

//Protocols
protocol SelectedCellProtocol: class {
    func didSelectedCell(view: DetailViewController)
    func didPopCell(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
}

extension SelectedCellProtocol{
    func didPopCell(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController){
        
    }
}


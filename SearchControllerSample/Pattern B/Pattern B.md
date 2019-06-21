#  Pattern B

Pattern Aから，UISearchController.searchBar.delegateだけMasterに移したパターンである

MasterとSearchResultの表示形態があまりにもかけ離れている/一緒にするとMasterのTableViewDataSource,Delegateが肥大化しすぎる場合に使える．

- SearchResultController: SearchResultControllerB
- SearchResultUpdating: SearchResultControllerB
- UISearchController.searchBar.delegate: MasterViewControllerB
- NavigateFromSearchResultProtocolを使用

```swift:MasterViewControllerB.swift
override func viewDidLoad() {
    ...
    
    let resultController = SearchResultViewControllerB()
    resultController.navigationDelegate = self  // SearchResultViewControllerからのnavigation遷移をキャッチする
    self.mySearchController = UISearchController(searchResultsController: resultController)  // 検索結果を表示するViewを設定
    self.mySearchController.searchResultsUpdater = resultController  // 検索されると動くViewを設定
    
    let searchBar = self.searchController.searchBar  // searchBarを取得
    searchBar.delegate = self
    
    ...
}
```

# コメント
## func searchBar(_:, selectedScopeButtonIndexDidChange:) が簡素
scopeを使うなら，searchControllerを持っているクラスがdelegateになっていると，検索を綺麗にまとめられると思う．
`self.searchController.searchResultsUpdater?.updateSearchResults(for: self.searchController)`だけで検索がかかる．
しかし，PatternCの方がもっと簡素．

```swift:MasterViewControllerB.swift

extension MasterViewControllerB: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searchController.searchResultsUpdater?.updateSearchResults(for: self.searchController)
    }

}

```

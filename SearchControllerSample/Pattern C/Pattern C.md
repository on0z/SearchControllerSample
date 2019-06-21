#  Pattern C

MasterとSearchResultController が同一のパターンである．
Masterで検索結果の表示も行う．
MasterとSearchResultControllerの表示形態が同じ場合に使いやすい．

- SearchResultController: MasterViewControllerC
- SearchResultUpdating: MasterViewControllerC
- UISearchController.delegate: MasterViewControllerC

```swift:MasterViewControllerC.swift

override func viewDidLoad() {
    ...

    // 検索に関する設定
    self.searchController = UISearchController(searchResultsController: nil)  // 検索結果を表示するViewControllerが自分なら，nilを設定
    self.searchController.searchResultsUpdater = self  // 検索されると動くViewを設定
    
    let searchBar = self.searchController.searchBar  // searchBarを取得
    searchBar.delegate = self
}
```

# コメント
## func searchBar(_:, selectedScopeButtonIndexDidChange:) が簡素

searchControllerも`func updateSearchResults(for:)`もMasterViewControllerCが持っているので，とても簡素．

```
extension MasterViewControllerC: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.updateSearchResults(for: self.searchController)
    }

}
```

## バッドエクスペリエンスを簡単に回避できる
Pattern A, B では

```swift:SearchResultViewControllerB.swift

extension SearchResultViewControllerB: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredItems = MasterViewControllerB().data.filter{...}
    }
}
    
```
のように検索が実装されており，これはあまりいただけない．
しかし，ちょっと検索機能をつけたいだけの時に，わざわざ検索関数をSearchResultControllerから見えるところに別で作らないといけないのは面倒である．

Pattern Cでは自分がdata配列を持っているので，

```swift:MasterViewControllerC.swift

extension MasterViewControllerC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredItems = self.data.filter{...}
    }
}

```
とかける．簡単である．

## TableViewDataSource, Delegate周りが面倒
同じTableViewControllerを用いて検索結果も表示するので，TableViewDataSource, Delegateが肥大化する．
MasterとSearchResultの表示形態があまりにもかけ離れている場合はオススメできない．

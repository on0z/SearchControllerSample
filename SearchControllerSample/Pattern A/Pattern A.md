#  Pattern A

MasterとSearchResultController 完全分離パターンである．

MasterとSearchResultの表示形態があまりにもかけ離れている/一緒にするとMasterのTableViewDataSource,Delegateが肥大化しすぎる場合に使える．

- SearchResultController: SearchResultControllerA
- SearchResultUpdating: SearchResultControllerA
- UISearchController.searchBar.delegate: SearchResultControllerA
- NavigateFromSearchResultProtocolを使用

```swift:MasterViewControllerA.swift
override func viewDidLoad() {
    ...
    
    let resultController = SearchResultViewControllerA()
    resultController.navigationDelegate = self  // SearchResultViewControllerからのnavigation遷移をキャッチする
    self.mySearchController = UISearchController(searchResultsController: resultController)  // 検索結果を表示するViewを設定
    self.mySearchController.searchResultsUpdater = resultController  // 検索されると動くViewを設定
    
    let searchBar = self.searchController.searchBar  // searchBarを取得
    searchBar.delegate = resultController
    
    ...
}
```

# コメント
## スコープなど，SearchBarDelegateをフックしずらい．
ちょっと考えれば華麗な解決法が浮かぶと思うが，めんどくさい．

SearchBarのScopeを押すと，SearchResultViewControllerAの`func searchBar(_:, selectedScopeButtonIndexDidChange:)`が呼ばれる．
つまり，この中で検索をしてやればいいわけである．
今回は簡易実装なので，主な検索処理は`func updateSearchResults(for:)` にある．
これをぜひ呼びたいところであるが，SearchResultViewControllerAはsearchControllerを持っていないので，呼べないのである．
MasterAからSearchResultViewControllerAにsearchControllerを渡してやるか，
同じ処理を`func searchBar(_:, selectedScopeButtonIndexDidChange:)`にも書かなければならない．
ああめんどくさい．

次項でも言うが，
普通のアプリであれば，検索関数を整備した上でUIを組んでいくと思われる．
なので，`func updateSearchResults(for:)` でも，`func searchBar(_:, selectedScopeButtonIndexDidChange:)`でも，
用意した検索関数を呼べば済むだけのはずである．

つまりこの実装方法は簡易実装には向いていない．
(「MasterとSearchResultの表示形態があまりにもかけ離れている」と言うような仕様は簡易実装とは程遠い気もする．)

## 検索がバッドエクスペリエンス
検索が

```swift:SearchResultViewControllerA.swift

extension SearchResultViewControllerA: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredItems = MasterViewControllerA().data.filter{...}
    }
}

```
のように実装されている．
これはあくまで例なのでこの方法を採用したが，実際にはこんな書き方をしてはならない．
というか，こんな書き方では一般的にはまともなアプリを実装できない．
ちゃんとデータを取ってくるためには，元データをグローバルな場所に置くか，MasterViewControllerAがSearchResultViewControllerAから見えないといけない．

普通のアプリであれば，検索関数を整備した上でUIを組んでいくと思われる．
その場合は，`func updateSearchResults(for:)` 内で検索関数を呼べばいいだけである．
入力された検索ワードの取得方法は，サンプルコードに載っている．

しかし，ちょっと検索機能をつけたいだけの時に，それらをするのは面倒である．
Pattern Cをオススメしたい．


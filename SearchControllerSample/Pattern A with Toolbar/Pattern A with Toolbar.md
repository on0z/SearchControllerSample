#  Pattern A with Toolbar

Pattern Aにおいて，`MasterViewControllerAt.navigationController`のToolbarを表示するサンプル．

変更点は2点

- `func viewDidLoad()`内で，Toolbarを表示する

```swift:MasterViewControllerAt.swift

override func viewDidLoad() {
    ...
    
    self.navigationController?.setToolbarHidden(false, animated: true)
}

```

- `DetailViewController`をPushする時に，ボトムバー(Tabbar, Toolbarのこと)を非表示にする

```swift:MasterViewControllerAt.swift

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let DetailView = DetailViewController()
    DetailView.text = data[indexPath.row]
    DetailView.hidesBottomBarWhenPushed = true  // new!
    self.navigationController?.pushViewController(DetailView, animated: true)
}

```

```swift:SearchResultViewControllerAt.swift

class SearchResultViewControllerAt: SearchResultViewControllerA {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        DetailView.text = self.filteredItems[indexPath.row]
        DetailView.hidesBottomBarWhenPushed = true  // new!
        self.navigationDelegate?.navigationControllerPush(fromSearchResult: DetailView)
    }

}

```

# ポイント
このToolbarはUINavigationControllerが持っている．
SearchResultControllerはnavigationControllerを持っていないので，MasterViewControllerAtが出す必要がある．
MasterViewControllerAtがToolbarを出せば，その上にSearchResultControllerを出してもToolbarは見える．

検索中*だけ*表示させたい場合，どうやって出させるかだが，
`UISearchControllerDelegate`をMasterViewControllerAtにかければ良い．

```swift

class MasterViewControllerAt: UITableViewController{
    override func viewDidLoad(){
        ...
        
        self.searchController.delegate = self
        
        ...
    }
}

extension MasterViewControllerAt: UISearchControllerDelegate{
    func willPresentSearchController(_ searchController: UISearchController){
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
}

```
のように実装できるだろう．

そして，Toolbarを閉じるタイミングだが，同じように

```swift

extension MasterViewControllerAt: UISearchControllerDelegate{
    func willDismissSearchController(_ searchController: UISearchController){
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}

```

としても良いだろう．
willやdidを変えてみたりして，ちゃんと動く実装を探してみたら良いだろう．

# コメント
ちなみに，Pattern CのようなMasterとSearchResultController が同一のパターンでは，MasterがnavigationControllerを持っているので，好きなタイミングでToolbarを出せる．

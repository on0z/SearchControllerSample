//
//  DetailViewController.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2016/08/03.
//

import UIKit

class DetailViewController: UIViewController {
    
    //選択された要素を入れる。表示にも使い回す。
    var text = "none"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail"
        self.view.backgroundColor = UIColor.white//背景を白色にする
        let label: UILabel = UILabel()//ラベルを作る
        label.text = text//ラベルのテキストを選択された文字列にする
        label.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)//ラベルの大きさを設定する
        label.center = self.view.center//ラベルの位置を真ん中にする
        label.textAlignment = .center//テキストを中央揃えにする
        self.view.addSubview(label)//ラベルを表示する
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

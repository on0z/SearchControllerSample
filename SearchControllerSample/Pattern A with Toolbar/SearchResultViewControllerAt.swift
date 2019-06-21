//
//  SearchResultViewControllerAt.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2019/06/21.
//  Copyright © 2019 on0z. All rights reserved.
//

import UIKit

class SearchResultViewControllerAt: SearchResultViewControllerA {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailView = DetailViewController()
        DetailView.text = self.filteredItems[indexPath.row]
        DetailView.hidesBottomBarWhenPushed = true
        self.navigationDelegate?.navigationControllerPush(fromSearchResult: DetailView)
    }
    
}

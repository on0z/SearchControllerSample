//
//  NavigateFromSearchResultProtocol.swift
//  SearchControllerSample
//
//  Created by 原園征志 on 2019/06/21.
//

import UIKit

protocol NavigateFromSearchResultProtocol: class {
    func navigationControllerPush(fromSearchResult viewController: DetailViewController)
    func previewingContext(fromSearchResult previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
}

extension NavigateFromSearchResultProtocol{
    func previewingContext(fromSearchResult previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController){
        
    }
}

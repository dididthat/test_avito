//
//  CatalogFlowFactory.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import UIKit

struct CatalogFlowFactory {
    func catalogFlow(navigationDelegate: CatalogPresenterNavigationDelegate) -> UIViewController {
        let presenter = CatalogPresenter(navigationDelegate: navigationDelegate)
        let viewController = CatalogViewController(output: presenter)
        presenter.input = viewController
        return viewController
    }
}

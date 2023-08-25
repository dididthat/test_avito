//
//  AppCoordinator.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import Foundation
import UIKit
import MessageUI

final class AppCoordinator: NSObject {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let flow = CatalogFlowFactory().catalogFlow(navigationDelegate: self)
        navigationController?.pushViewController(flow, animated: true)
    }
}

// MARK: - CatalogPresenterNavigationDelegate
extension AppCoordinator: CatalogPresenterNavigationDelegate {
    func catalogPresenterDidRequestOpenDetailsFlow(
        _ preseneter: CatalogPresenter,
        with container: ProductDetailsFlowDependenciesContainer
    ) {
        let flow = ProductDetailsFlowFactory().productDetailsFlow(
            container: container,
            navigationDelegate: self
        )
        navigationController?.pushViewController(flow, animated: true)
    }
}

// MARK: - ProductDetailsPresenterNavigationDelegate
extension AppCoordinator: ProductDetailsPresenterNavigationDelegate {
    func productDetailsPresenterDidRequestOpenEmailFlow(
        _ presenter: ProductDetailsPresenter,
        email: String
    ) {
        guard
            let lastViewController = navigationController?.viewControllers.last
        else {
            return
        }
            
        let flow = MessageFlowFactory().messageFlow(
            email: email,
            mailComposeDelegate: self
        )
        
        lastViewController.present(flow, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension AppCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}

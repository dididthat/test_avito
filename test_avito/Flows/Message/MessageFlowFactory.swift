//
//  MessageFlowFactory.swift
//  test_avito
//
//  Created by Diana Nikulina on 25.08.2023.
//

import MessageUI

struct MessageFlowFactory {
    func messageFlow(
        email: String,
        mailComposeDelegate: MFMailComposeViewControllerDelegate
    ) -> UIViewController {
        let viewController =  MFMailComposeViewController()
        viewController.setToRecipients([email])
        viewController.mailComposeDelegate = mailComposeDelegate
        return viewController
    }
}

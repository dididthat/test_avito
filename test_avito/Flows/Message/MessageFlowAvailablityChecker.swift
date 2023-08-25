//
//  MessageFlowAvailablityChecker.swift
//  test_avito
//
//  Created by Diana Nikulina on 25.08.2023.
//

import MessageUI

struct MessageFlowAvailablityChecker {
    func check() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
}

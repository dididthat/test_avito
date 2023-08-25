//
//  InAppNotificationManager.swift
//  test_avito
//
//  Created by Diana Nikulina on 25.08.2023.
//

import Foundation
import UIKit

final class InAppNotificationManager {
    
    static let shared = InAppNotificationManager()
    
    private init() {}
    
    func showNotification(message: String) {
        guard let keyWindow = UIApplication.shared.windows.first else {
            return
        }
        
        let notificationView = UIView()
        notificationView.backgroundColor = .green.withAlphaComponent(0.7)
        notificationView.layer.cornerRadius = 14
        notificationView.clipsToBounds = true
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        notificationView.addSubview(label)
        keyWindow.addSubview(notificationView)
        
        NSLayoutConstraint.activate([
            notificationView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 16),
            keyWindow.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: 16),
            keyWindow.safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: notificationView.bottomAnchor,
                constant: 16
            ),
            
            label.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 10),
            notificationView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 10),
            notificationView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
        ])
        
        UIView.animate(withDuration: 0.3) {
            notificationView.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0) {
                notificationView.alpha = 0.0
            } completion: { _ in
                notificationView.removeFromSuperview()
            }
        }
    }
}

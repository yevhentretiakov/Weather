//
//  ViewController+Ext.swift
//  Weather
//
//  Created by user on 12.06.2022.
//

import UIKit

extension UIViewController {
    
    func impactOccured(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notificationOccurred(style: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style)
    }
    
    func presentAlert(message: ErrorMessage) {
        notificationOccurred(style: .error)
        let vc = AlertVC()
        vc.message = NSLocalizedString(message.rawValue, comment: "")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
}

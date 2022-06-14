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
}

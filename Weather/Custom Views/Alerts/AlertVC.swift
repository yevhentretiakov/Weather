//
//  AlertVC.swift
//  Weather
//
//  Created by user on 15.06.2022.
//

import UIKit

class AlertVC: UIViewController {
    
    var message: String?
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalView()
        configureButton()
        configureLabel()
    }
    
    private func configureLabel() {
        messageLabel.text = message
    }
    
    private func configureModalView() {
        modalView.layer.cornerRadius = 5
    }
    
    private func configureButton() {
        actionButton.layer.cornerRadius = 5
    }
    
    @IBAction private func buttonTapped(_ sender: Any) {
        impactOccured(style: .light)
        dismiss(animated: true)
    }
}

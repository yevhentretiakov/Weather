//
//  AlertVC.swift
//  Weather
//
//  Created by user on 15.06.2022.
//

import UIKit

class AlertVC: UIViewController {
    
    var message: String?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalView()
        configureButton()
        configureLabel()
    }
    
    func configureLabel() {
        messageLabel.text = message
    }
    
    func configureModalView() {
        modalView.layer.cornerRadius = 5
    }
    
    func configureButton() {
        actionButton.layer.cornerRadius = 5
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

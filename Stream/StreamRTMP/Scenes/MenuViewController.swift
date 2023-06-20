//
//  MenuViewController.swift
//  StreamRTMP
//
//  Created by Alexandr Arsenyuk on 24.04.2023.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let gradientLayer = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientView()
        setupButtons()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gradientLayer.removeFromSuperlayer()
        setupGradientView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        settingsLabel.textColor = AppConstants.buttonHighlightedText
        settingsLabel.text = Defaults.shared.settings.description
        settingsLabel.textAlignment = .center
    }
    
    private func setupButtons() {
        
        liveButton.setTitle("Go Live", for: .normal)
        settingsButton.setTitle("Settings", for: .normal)
        
        [liveButton, settingsButton].forEach { button in
            button?.backgroundColor = AppConstants.buttonBackgroundColor
            button?.setTitleColor(AppConstants.buttonNormalText, for: .normal)
            button?.setTitleColor(AppConstants.buttonHighlightedText, for: .highlighted)
            button?.layer.cornerRadius = 12
            button?.clipsToBounds = true
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
    }
    
    private func setupGradientView() {
        
        gradientLayer.colors = [
            AppConstants.gradientTopColor.cgColor,
            AppConstants.gradientBottomColor.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    
    @IBAction func liveButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let liveViewController = storyboard.instantiateViewController(withIdentifier: "LiveViewController")
        liveViewController.modalPresentationStyle = .fullScreen
        self.present(liveViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let liveViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        liveViewController.modalPresentationStyle = .fullScreen
        self.present(liveViewController, animated: true, completion: nil)
    }
    
}

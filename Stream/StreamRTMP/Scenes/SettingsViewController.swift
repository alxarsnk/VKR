//
//  SettingsViewController.swift
//  StreamRTMP
//
//  Created by Alexandr Arsenyuk on 24.04.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    
    @IBOutlet weak var resolutionButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    let gradientLayer = CAGradientLayer()
    
    private var settingsModel: SettingsModel {
        get {
            Defaults.shared.settings
        }
        set {
            Defaults.shared.settings = newValue
        }
    }
    private var address: String?
    private var name: String?
    private var resolution: Resolution?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientView()
        setupViews()
        setupButton()
        prefillSettings()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gradientLayer.removeFromSuperlayer()
        setupGradientView()
    }
    
    private func prefillSettings() {
        addressTextField.text = settingsModel.serverAddress
        nameTextField.text = settingsModel.servername
        
        address = settingsModel.serverAddress
        name = settingsModel.servername
        resolution = settingsModel.resolution
        
        resolutionButton.setTitle(settingsModel.resolution.description(), for: .normal)
    }
    
    
    
    private func setupViews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        [nameTitle, addressTitle].forEach { title in
            title?.textColor = AppConstants.buttonHighlightedText
            title?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        
        addressTextField.tag = 1
        nameTextField.tag = 2
        [nameTextField, addressTextField].forEach { textField in
            textField?.backgroundColor = AppConstants.buttonBackgroundColor
            textField?.textColor = AppConstants.buttonNormalText
            textField?.delegate = self
        }
    }
    
    private func setupButton() {
        resolutionButton.setTitle("Resolution", for: .normal)
        resolutionButton.backgroundColor = AppConstants.buttonBackgroundColor
        resolutionButton.setTitleColor(AppConstants.buttonNormalText, for: .normal)
        resolutionButton.setTitleColor(AppConstants.buttonHighlightedText, for: .highlighted)
        resolutionButton.layer.cornerRadius = 12
        resolutionButton.clipsToBounds = true
        resolutionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
    
    private func updateData() {
        let newSettings = SettingsModel(
            resolution: resolution ?? .init(width: 1080, height: 720),
            serverAddress: address ?? "",
            servername: name ?? ""
        )
        settingsModel = newSettings
    }
    
    
    
    @IBAction func resolutionButtonPressed(_ sender: Any) {
        let hd = UIAction(title: Resolution.Resolutions.hd.description()) { [weak self] _ in
            self?.resolutionButton.setTitle(Resolution.Resolutions.hd.description(), for: .normal)
            self?.resolution = Resolution.Resolutions.hd
        }
        
        let fullHD = UIAction(title: Resolution.Resolutions.fullHD.description()) { [weak self] _ in
            self?.resolutionButton.setTitle(Resolution.Resolutions.fullHD.description(), for: .normal)
            self?.resolution = Resolution.Resolutions.fullHD
        }
        
        let k2 = UIAction(title: Resolution.Resolutions.K2.description()) { [weak self] _ in
            self?.resolutionButton.setTitle(Resolution.Resolutions.K2.description(), for: .normal)
            self?.resolution = Resolution.Resolutions.K2
        }
        
        let k4 = UIAction(title: Resolution.Resolutions.K4.description()) { [weak self] _ in
            self?.resolutionButton.setTitle(Resolution.Resolutions.K4.description(), for: .normal)
            self?.resolution = Resolution.Resolutions.K4
        }
        
        if #available(iOS 14.0, *) {
            resolutionButton.showsMenuAsPrimaryAction = true
            resolutionButton.menu = UIMenu(title: "", children: [hd, fullHD, k2, k4])
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        updateData()
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            address = addressTextField.text
        } else  if textField.tag == 2 {
            name = nameTextField.text
        }
    }
}

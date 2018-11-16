//
//  SettingsScreen.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/15/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit

protocol SettingsScreenDelegate: class {
    func dismisSettingsScreen()
}

class SettingsScreen: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var hostTxtField: UITextField!
    @IBOutlet weak var portTxtField: UITextField!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    weak var delegateSettings: SettingsScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.contentView.alpha = 0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        
        self.okBtn.layer.masksToBounds = true
        self.okBtn.layer.cornerRadius = 5
        
        self.cancelbtn.layer.masksToBounds = true
        self.cancelbtn.layer.cornerRadius = 5
        if let hostName = UsersDefaultsManager.getSavedHost()  {
            hostTxtField.text = hostName
        }
        if let hostPort = UsersDefaultsManager.getSavedPort() {
            portTxtField.text = hostPort
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { [weak self] in
            self?.contentView.alpha = 1
            self?.contentView.transform = .identity
        }) { (Finished) in
            
        }
    }
    private func showAlerts(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default) { (alertObj) in
            
        }
        alert.addAction(okAlert)
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: Notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            centerYConstraint.constant = -130
            UIView.animate(withDuration: 0.3) {  [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        if hostTxtField.text != "" && portTxtField.text != "" {
            UsersDefaultsManager.saveHost(hostName: hostTxtField.text!)
            UsersDefaultsManager.savePort(portName: portTxtField.text!)
            delegateSettings?.dismisSettingsScreen()
            dismiss(animated: false, completion: nil)
        } else {
            showAlerts(title: "შეცდომა", message: "გთხოვთ შეავსოთ ყველა ველი")
        }
    }
    
    @IBAction func justCancel(_ sender: UIButton) {
        delegateSettings?.dismisSettingsScreen()
        dismiss(animated: false, completion: nil)
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        centerYConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {  [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
}

extension SettingsScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == hostTxtField {
            portTxtField.becomeFirstResponder()
        }
        return true
    }
}

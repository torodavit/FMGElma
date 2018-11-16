//
//  LoginViewController.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/15/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraintLogo: NSLayoutConstraint!
    @IBOutlet weak var userNameStroke: UIImageView!
    @IBOutlet weak var passwordStroke: UIImageView!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var passwordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drawViews()
        if UIScreen.main.bounds.size.width == 320 {
            saveTopConstrant.constant = 15
            loginBtnTopConstraint.constant = 15
            passwordTopConstraint.constant = 10
        }
        addObservere()
    }
    private func addObservere(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    // MARK: Notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.topConstraint.constant = 20
            self.topConstraintLogo.constant = -200
            if UIScreen.main.bounds.size.width == 320 {
                self.topConstraint.constant = 10
            }
            UIView.animate(withDuration: 0.3) {  [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    private func showAlerts(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default) { (alertObj) in
            
        }
        alert.addAction(okAlert)
        self.present(alert, animated: true, completion: nil)
    }
    private func drawViews(){
        userNameStroke.layer.masksToBounds = true
        userNameStroke.layer.cornerRadius = 10
        userNameStroke.layer.borderWidth = 1.0
        userNameStroke.layer.borderColor = UIColor.black.cgColor
        passwordStroke.layer.masksToBounds = true
        passwordStroke.layer.cornerRadius = 10
        passwordStroke.layer.borderWidth = 1.0
        passwordStroke.layer.borderColor = UIColor.black.cgColor
        authBtn.layer.masksToBounds = true
        authBtn.layer.cornerRadius = 10
    }
    private func closeKeyboard(){
        self.view.endEditing(true)
        self.topConstraint.constant = 172
        self.topConstraintLogo.constant = 25
        UIView.animate(withDuration: 0.3) {  [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    private func loginUser(){
        if userNameTxtField.text != "" && passwordTxtField.text != "" {
            //Login Users
            let listScreen = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            self.navigationController?.pushViewController(listScreen, animated: true)
        } else {
                //Error Fill fields
            userNameStroke.layer.borderColor = UIColor.red.cgColor
            passwordStroke.layer.borderColor = UIColor.red.cgColor
            userNameTxtField.textColor = UIColor.red
            passwordTxtField.textColor = UIColor.red
            showAlerts(title: "შეცდომა", message: "გთხოვთ შეავსოთ ყველა ველი")
        }
    }
    @IBAction func loginUser(_ sender: UIButton) {
        loginUser()
    }
    
    @IBAction func showSettingsView(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        let settings = self.storyboard?.instantiateViewController(withIdentifier: "SettingsScreen") as! SettingsScreen
        settings.delegateSettings = self
        settings.view.backgroundColor = UIColor.clear
        settings.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(settings, animated: false, completion: nil)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        closeKeyboard()
    }

}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTxtField {
            passwordTxtField.becomeFirstResponder()
        } else {
            closeKeyboard()
            loginUser()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        userNameStroke.layer.borderColor = UIColor.black.cgColor
        passwordStroke.layer.borderColor = UIColor.black.cgColor
        userNameTxtField.textColor = UIColor.black
        passwordTxtField.textColor = UIColor.black
        return true
    }
}

extension LoginViewController: SettingsScreenDelegate {
    func dismisSettingsScreen() {
        self.addObservere()
    }
}

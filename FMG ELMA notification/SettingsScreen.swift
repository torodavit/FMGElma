//
//  SettingsScreen.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/15/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit

class SettingsScreen: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
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
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { [weak self] in
            self?.contentView.alpha = 1
            self?.contentView.transform = .identity
        }) { (Finished) in
            
        }
    }
}

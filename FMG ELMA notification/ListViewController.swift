//
//  ListViewController.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/16/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    var userId = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceManager.shared.getUserName(userId: userId) { [weak self] (userName) in
            self?.titleLbl.text = userName
        }
        ServiceManager.shared.getTODOListBuyUser(userId: userId, listStatus: 1) { (list) in
            
        }
    }
    
    @IBAction func backTo(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

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
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var list = Array<TODOModel>()
    var userId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 110.0;
        ServiceManager.shared.getUserName(userId: userId) { [weak self] (userName) in
            self?.titleLbl.text = userName
        }
        ServiceManager.shared.getTODOListBuyUser(userId: userId, listStatus: 1) { [weak self] (list) in
            self?.list = list
            self?.loader.stopAnimating()
            self?.tableView.reloadData()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func seenAllToDoList(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        self.loader.startAnimating()
        var countTodoList = 0
        for obj in list {
            ServiceManager.shared.seenToDo(with: obj.IdMessagesForAndorid!) { [weak self] (message) in
                countTodoList += 1
                if countTodoList == self?.list.count {
                    self?.view.isUserInteractionEnabled = true
                    self?.loader.stopAnimating()
                    if message == "Ok" {
                        self?.showAlerts(title: "წარმატება", message: "წარმატებით შეასრულეთ ყველა დავალება")
                    } else {
                        self?.showAlerts(title: "შეცდომა", message: "დაფიქსირდა შეცდომა გთხოვთ ცადოთ თავიდან")
                    }
                }
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
    
    @IBAction func reloadData(_ sender: UIButton) {
        self.loader.startAnimating()
        self.view.isUserInteractionEnabled = false
        ServiceManager.shared.getTODOListBuyUser(userId: userId, listStatus: 1) { [weak self] (list) in
            self?.list = list
            self?.loader.stopAnimating()
            self?.tableView.reloadData()
            self?.view.isUserInteractionEnabled = true
        }
    }
    @IBAction func backTo(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        let obj = list[indexPath.row]
        if let seen = obj.SeenDate {
            cell.seenDate.text = "ნანახია: \(seen)"
        }
        cell.titleLbl.text = obj.message
        if let dataStart = obj.DataStart{
            if let dataEnd = obj.DataEnd {
                cell.todoRange.text = "\(dataStart) -> \(dataEnd)"
            }
        }
        if obj.Seen == 1 {
            
        } else {
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = list[indexPath.row]
        self.view.isUserInteractionEnabled = false
        self.loader.startAnimating()
        ServiceManager.shared.seenToDo(with: obj.IdMessagesForAndorid!) { [weak self] (message) in
            self?.view.isUserInteractionEnabled = true
            self?.loader.stopAnimating()
            if message == "Ok" {
                self?.showAlerts(title: "წარმატება", message: "წარმატებით შეასრულეთ დავალება")
            } else {
                self?.showAlerts(title: "შეცდომა", message: "დაფიქსირდა შეცდომა გთხოვთ ცადოთ თავიდან")
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

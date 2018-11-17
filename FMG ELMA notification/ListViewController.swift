//
//  ListViewController.swift
//  ELMA notification
//
//  Created by Tornike Davitashvili on 11/16/18.
//  Copyright © 2018 Tornike Davitashvili. All rights reserved.
//

import UIKit
import OneSignal

class ListViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()

    var list = Array<TODOModel>()
    var userId = -1
    var seenColor = UIColor.gray
    var unSeenColor = UIColor.black
    
    var seenFont = UIFont(name: "HelveticaNeue-Light", size: 14)
    var unSeenFont = UIFont(name: "HelveticaNeue-Bold", size: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 110.0;
        ServiceManager.shared.getUserName(userId: userId) { [weak self] (userName) in
            OneSignal.sendTag("UserFullName", value: userName)
            self?.titleLbl.text = userName
        }
        ServiceManager.shared.getTODOListBuyUser(userId: userId, listStatus: 1) { [weak self] (list) in
            self?.list = list
            self?.loader.stopAnimating()
            self?.tableView.reloadData()
            self?.view.isUserInteractionEnabled = true
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        // Code to refresh table view
        ServiceManager.shared.getTODOListBuyUser(userId: userId, listStatus: 1) { [weak self] (list) in
            self?.list = list
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()

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
            cell.titleLbl.textColor = seenColor
            cell.rangeLbl.textColor = seenColor
            cell.todoRange.textColor = seenColor
            cell.seenDate.textColor = seenColor
            
            cell.titleLbl.font = seenFont
            cell.rangeLbl.font = seenFont
            cell.todoRange.font = seenFont
            cell.seenDate.font = seenFont
        } else {
            cell.titleLbl.textColor = unSeenColor
            cell.rangeLbl.textColor = unSeenColor
            cell.todoRange.textColor = unSeenColor
            cell.seenDate.textColor = unSeenColor
            
            cell.titleLbl.font = unSeenFont
            cell.rangeLbl.font = unSeenFont
            cell.todoRange.font = unSeenFont
            cell.seenDate.font = unSeenFont
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

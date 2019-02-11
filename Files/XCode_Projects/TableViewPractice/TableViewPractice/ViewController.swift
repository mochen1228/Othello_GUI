//
//  ViewController.swift
//  TableViewPractice
//
//  Created by ChenMo on 1/7/19.
//  Copyright © 2019 ChenMo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    let students: [String] = ["A", "B", "C"];
    
    func tableView(_ tableView:UITableView!, numberOfRowsInSection section:Int) -> Int {
        return students.count
    }
    
    
}


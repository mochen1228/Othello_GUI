//
//  ViewController.swift
//  CS125Demo
//
//  Created by ChenMo on 2/1/18.
//  Copyright © 2018 ChenMo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Go(_ sender: UIButton) {
        let url = URL(string: "https://us-central1-cs125-ed969.cloudfunctions.net/helloWorld")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.ascii.rawValue)!)
        }
        
        task.resume()
    }
    
}


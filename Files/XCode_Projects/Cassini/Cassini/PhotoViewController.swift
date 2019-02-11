//
//  PhotoViewController.swift
//  Cassini
//
//  Created by ChenMo on 5/11/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let photo = segue.destination as? ImageViewController {
                print(url)
                photo.imageURL = url;
            }
        }
    }

}

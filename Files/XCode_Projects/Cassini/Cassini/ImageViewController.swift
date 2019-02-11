//
//  ImageViewController.swift
//  Cassini
//
//  Created by ChenMo on 5/10/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageURL: URL? {
        didSet {
            image = nil;
            if (view.window != nil) {
                getImage();
            }
        }
    }
    
    fileprivate var imageView = UIImageView();
    
    private var image: UIImage? {
        set {
            imageView.image = newValue;
            imageView.sizeToFit();
            scrollView?.contentSize = imageView.frame.size;
            if image != nil {
                fidgetSpinner.stopAnimating();
            }
        }
        get {
            return imageView.image;
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self;
            scrollView.maximumZoomScale = 1.0;
            scrollView.minimumZoomScale = 0.05;
            scrollView.addSubview(imageView);
        }
    }
    
    @IBOutlet weak var fidgetSpinner: UIActivityIndicatorView!
    
    private func getImage() {
        if let url = imageURL {
            fidgetSpinner.startAnimating();
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let fetchedData = try? Data(contentsOf: url);
                if let imageData = fetchedData, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData);
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(_: false);
        getImage();
        // view.addSubview(scrollView);
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
}

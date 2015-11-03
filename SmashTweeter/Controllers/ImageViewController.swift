//
//  ImageViewController.swift
//  SmashTweeter
//
//  Created by Xing Hui Lu on 11/2/15.
//  Copyright © 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate  {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 0.3
        }
    }
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
            activityIndicator?.stopAnimating()
            
            scrollView?.contentSize = imageView.frame.size
            autoScale()
        }
    }
    
    func autoScale() {
        if let sv = scrollView {
            if image != nil {
                // Display zoomed to show as much of the image as possible but with no "white space"
                print("sv.bounds.size.height: \(sv.bounds.size.height)  image!.size.height: \(image!.size.height)   = \(sv.bounds.size.height / image!.size.height)")
                print("sv.bounds.size.width: \(sv.bounds.size.width)    image!.size.width: \(image!.size.width)     = \(sv.bounds.size.width / image!.size.width)")

                sv.zoomScale = max(
                    sv.bounds.size.height / image!.size.height,     // height ratio     i.e. 618/1024 = 0.603515625
                    sv.bounds.size.width / image!.size.width        // width ratio      i.e. 375/576 = 0.651041666666667
                )
                sv.contentOffset = CGPoint(
                    x: (imageView.frame.size.width - sv.frame.size.width)/2,
                    y: (imageView.frame.size.height - sv.frame.size.height)/2
                )
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            activityIndicator?.startAnimating()
            
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            let queue = dispatch_get_global_queue(qos, 0)
            
            dispatch_async(queue) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Viewcontroller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }
    
    // MARK: - ScrollView Delegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

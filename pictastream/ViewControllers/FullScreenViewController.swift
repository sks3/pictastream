//
//  FullScreenViewController.swift
//  pictastream
//
//  Created by somi on 2/19/18.
//  Copyright © 2018 Somi Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class FullScreenViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet var zoomImage: UIImageView!
  @IBOutlet var scrollView: UIScrollView!
  
  var post: [String: Any]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    
    if let post = post {
      //let post = posts[indexPath.row]
      //if let photos = post["photos"] as? [[String: Any]] {
      let photos = post["photos"] as! [[String: Any]]
      let photo = photos[0]
      let originalSize = photo["original_size"] as! [String: Any]
      let urlString = originalSize["url"] as! String
      let url = URL(string: urlString)
      zoomImage.af_setImage(withURL: url!)
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return zoomImage
  }
  
  @IBAction func doneViewing(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}

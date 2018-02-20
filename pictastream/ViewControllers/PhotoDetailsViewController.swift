//
//  PhotoDetailsViewController.swift
//  pictastream
//
//  Created by somi on 2/15/18.
//  Copyright © 2018 Somi Singh. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

  @IBOutlet weak var detailImage: UIImageView!
  
  var post: [String: Any]?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGesture:)))
    detailImage.isUserInteractionEnabled = true
    detailImage.addGestureRecognizer(tapGesture)
    
    if let post = post {
      //let post = posts[indexPath.row]
      //if let photos = post["photos"] as? [[String: Any]] {
      let photos = post["photos"] as! [[String: Any]]
      let photo = photos[0]
      let originalSize = photo["original_size"] as! [String: Any]
      let urlString = originalSize["url"] as! String
      let url = URL(string: urlString)
      detailImage.af_setImage(withURL: url!)
      
    }
  }
  
  @objc func imageTapped(tapGesture: UITapGestureRecognizer) {
    performSegue(withIdentifier: "FullScreen", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationNavigationController = segue.destination as! UINavigationController
    let fullScreenController = destinationNavigationController.topViewController as! FullScreenViewController
    fullScreenController.post = post
  }
}

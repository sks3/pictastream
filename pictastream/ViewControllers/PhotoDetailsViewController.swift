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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

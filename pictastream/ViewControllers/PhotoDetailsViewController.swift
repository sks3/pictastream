/// Copyright (c) 2018 Somi Singh
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class PhotoDetailsViewController: UIViewController {
  
  @IBOutlet weak var detailImage: UIImageView!
  
  // global variable for post
  var post: [String: Any]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // recognize tap on picture to trigger modal segue
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGesture:)))
    detailImage.isUserInteractionEnabled = true
    detailImage.addGestureRecognizer(tapGesture)
    
    // load image from post and attach to detailImage
    if let post = post {
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
  
  // send post to fullscreen view controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationNavigationController = segue.destination as! UINavigationController
    let fullScreenController = destinationNavigationController.topViewController as! FullScreenViewController
    fullScreenController.post = post
  }
}

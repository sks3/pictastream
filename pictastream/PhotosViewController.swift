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
import AlamofireImage
import iProgressHUD

private let reuseIdentifier = "Cell"

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  var posts: [[String: Any]] = []
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize refresh control
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 275
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // Configure HUD and attach to view
    let iprogress: iProgressHUD = iProgressHUD()
    iprogress.isShowModal = true
    iprogress.isBlurModal = true
    iprogress.isShowCaption = true
    iprogress.isTouchDismiss = true
    iprogress.indicatorStyle = .ballGridPulse
    iprogress.indicatorSize = 65
    iprogress.boxSize = 40
    iprogress.captionSize = 20
    iprogress.attachProgress(toView: view)
    view.showProgress()
    getTumblrImages()
  }
  
  
  @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
    // Set caption for HUD
    view.updateCaption(text: "Refreshing...")
    view.showProgress()
    getTumblrImages()
  }
  
  // Retrieve Humans of NewYork images from Tumblr API
  func getTumblrImages() {
    let url = URL(string: "https://api.tumblr.com/v2/blog/unitedstatesnationalparks-blog.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    //session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error.localizedDescription)
      }
      else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        //print(dataDictionary)
        
        // Get dictionary from response key
        let responseDictionary = dataDictionary["response"] as! [String: Any]
        
        // Store returned array of dictionaries in posts property
        self.posts = responseDictionary["posts"] as! [[String: Any]]
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.view.dismissProgress()
      }
    }
    task.resume()
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    let post = posts[indexPath.row]
    //if let photos = post["photos"] as? [[String: Any]] {
      let photos = post["photos"] as! [[String: Any]]
      let photo = photos[0]
      let originalSize = photo["original_size"] as! [String: Any]
      let urlString = originalSize["url"] as! String
      let url = URL(string: urlString)
      cell.tumblrImage.af_setImage(withURL: url!)
    //}
    return cell
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

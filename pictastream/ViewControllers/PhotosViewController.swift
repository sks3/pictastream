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
var alertController: UIAlertController!

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var posts: [[String: Any]] = []
  var posts1: [[String: Any]] = []
  var isMoreDataLoading = false
  var offset = 0
  var totalPosts = 0
  
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 275
    scrollView.delegate = self
    
    // Initialize refresh control
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    // alert user if no network connection is found
    alertController = UIAlertController(title: "Cannot Retrieve Images", message: "The Internet Connection is Offline", preferredStyle: .alert)
    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) {(action) in self.getTumblrImages()}
    alertController.addAction(tryAgainAction)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollViewOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      
      if (scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.isDragging) {
        isMoreDataLoading = true
        getTumblrImages()
      }
    }
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
    if (posts.count == 0) {
      getTumblrImages()
    }
    else {
      view.dismissProgress()
    }
  }
  
  @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
    // Set caption for HUD
    view.updateCaption(text: "refreshing...")
    view.showProgress()
    offset = 0
    getTumblrImages()
  }
  
  // Retrieve U.S. Parks images from Tumblr API
  func getTumblrImages() {
    view.showProgress()
    if (isMoreDataLoading && offset + 20 < totalPosts) {
      offset += 20
    }
    
    // US Parks tumblr feed
    //let url = URL(string: "https://api.tumblr.com/v2/blog/unitedstatesnationalparks-blog.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
    
    // Humans of New York tumblr feed
    let baseUrl = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    
    let urlOffset = "&offset=" + String(offset)
    let url = URL(string: baseUrl + urlOffset)!
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        // display alert for user to retry connection
        self.present(alertController, animated: true)
        print(error.localizedDescription)
      }
      else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let responseDictionary = dataDictionary["response"] as! [String: Any]
        self.totalPosts = responseDictionary["total_posts"] as! Int
        
        if (self.isMoreDataLoading) {
          self.posts1 = responseDictionary["posts"] as! [[String: Any]]
          self.posts.append(contentsOf: self.posts1)
          self.isMoreDataLoading = false
        }
        else {
          self.posts = responseDictionary["posts"] as! [[String: Any]]
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.view.dismissProgress()
      }
    }
    task.resume()
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    
    let profileView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
    profileView.layer.borderWidth = 1
    profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
    headerView.addSubview(profileView)
    
    let label = UILabel(frame: CGRect(x: 65, y: 5, width: 280, height: 30))
    let post = posts[section]
    label.text = post["date"] as? String
    headerView.addSubview(label)
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    
    // display placeholder image until landscape loads
    let placeholderImage = UIImage(named: "placeholder")
    
    // specify animation technique for image transition
    let filter = AspectScaledToFillSizeFilter(size: cell.tumblrImage.frame.size)
    
    //set cell selection effect
    cell.selectionStyle = .none
    
    let post = posts[indexPath.section]
    let photos = post["photos"] as! [[String: Any]]
    let photo = photos[0]
    let originalSize = photo["original_size"] as! [String: Any]
    let urlString = originalSize["url"] as! String
    let url = URL(string: urlString)
    cell.tumblrImage.af_setImage(withURL: url!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.3))
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    if let indexPath = tableView.indexPath(for: cell) {
      let post = posts[indexPath.section]
      let detailViewController = segue.destination as! PhotoDetailsViewController
      detailViewController.post = post
    }
  }
}

//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Dominique Macias on 6/16/16.
//  Copyright © 2016 Dominique Macias. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts: [NSDictionary] = []

    @IBOutlet weak var photoView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.delegate = self
        photoView.dataSource = self
        

        let url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                                                                                
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.photoView.reloadData()
                }
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        
        UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        //photoView.rowHeight = 240
            
            
        let post = posts[indexPath.row]
            
        if let photos = post.valueForKeyPath("photos") as? [NSDictionary] {
            let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            if let imageUrl = NSURL(string: imageUrlString!) {
                cell.photoView.setImageWithURL(imageUrl)
                // NSURL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
            } else {
                // NSURL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }

            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
            return cell
    }
    

    
    // MARK: - Navigationr

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        var indexPath = photoView.indexPathForCell(sender as! UITableViewCell)
        
        let post = posts[indexPath!.row]
        
        if let photos = post.valueForKeyPath("photos") as? [NSDictionary] {
            let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            if let imageUrl = NSURL(string: imageUrlString!) {
                vc.photoURL = imageUrl
                // NSURL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
            } else {
                // NSURL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
            
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        
        
        // Pass the selected object to the new view controller.
    }
    

}

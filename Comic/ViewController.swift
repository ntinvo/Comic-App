//
//  ViewController.swift
//  Comic
//
//  Created by Tin Vo on 9/25/15.
//  Copyright © 2015 Tin Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /* Variables */
    var postID: Int = 1
    var imgURL: String = ""
    let LAST_POST_ID: Int = 1582
    let FIRST_POST_ID: Int = 1
    
    /* Outlets */
    @IBOutlet var img: UIImageView!
    
    /* Action for "Next" button */
    @IBAction func nextAction(sender: AnyObject) {
        /* Go to the next postID (if above LAST_POST_ID
        then goes back to FIRST_POST_ID) */
        postID++
        if (postID > LAST_POST_ID) {
            postID = FIRST_POST_ID
        }
        
        /* Parse and display */
        parseUrl("http://xkcd.com/" + String(postID) + "/")
    }
    
    /* Action for "Prev" button */
    @IBAction func prevAction(sender: AnyObject) {
        /* Go to the next postID (if below FIRST_POST_ID
        then goes back to LAST_POST_ID) */
        postID--
        if (postID < FIRST_POST_ID) {
            postID = LAST_POST_ID
        }
        
        /* Parse and display */
        parseUrl("http://xkcd.com/" + String(postID) + "/")
    }
    
    /* Parse the Url. We have to parse the content of the web and return
    the url of the image so that we can display it on the screen */
    func parseUrl(url: String) {
        let postUrl = NSURL(string: url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(postUrl!) { (data, res, err) -> Void in
            if let urlContent = data {
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                /* Parse with "Image URL (for hotlinking/embedding): " */
                let webItems = webContent?.componentsSeparatedByString("Image URL (for hotlinking/embedding): ")
                if(webItems!.count > 0) {
                    
                    /* Parse again with "<div" to get the image url */
                    let partialWebItems = webItems![1].componentsSeparatedByString("\n<div")
                    self.imgURL = partialWebItems[0]
                    self.display()
                }
            }
        }
        task.resume()
    }
    
    /* Display the picture */
    func display() {
        
        /* An NSURL object represents a URL that can potentially contain the location of a
        resource on a remote server, the path of a local file on disk, or even an arbitrary
        piece of encoded data */
        let url = NSURL(string: imgURL)
        
        /* An NSURLRequest object represents a URL load request in a
        manner independent of protocol and URL scheme */
        let urlReq = NSURLRequest(URL: url!)
        
        /* An NSURLConnection object lets you load the contents
        of a URL by providing a URL request object */
        NSURLConnection.sendAsynchronousRequest(urlReq, queue: NSOperationQueue.mainQueue()) { (res, data, err) -> Void in
            if (err != nil) {
                print(err)
            } else {
                if let xkcdImg = UIImage(data: data!) {
                    self.img.image = xkcdImg
                }
            }
        }
        /* Save the postID here so that the user can start where the left off */
        NSUserDefaults.standardUserDefaults().setObject(postID, forKey: "id")
    }
    
    
    /* Display the initial picture for the app */
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Reload the postID */
        postID = NSUserDefaults.standardUserDefaults().objectForKey("id") as! Int
        
        /* Parse and display */
        let url: String = "http://xkcd.com/" + String(postID) + "/"
        let postUrl = NSURL(string: url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(postUrl!) { (data, res, err) -> Void in
            if let urlContent = data {
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                /* Parse with "Image URL (for hotlinking/embedding): " */
                let webItems = webContent?.componentsSeparatedByString("Image URL (for hotlinking/embedding): ")
                if(webItems!.count > 0) {
                    
                    /* Parse again with "<div" to get the image url */
                    let partialWebItems = webItems![1].componentsSeparatedByString("\n<div")
                    self.imgURL = partialWebItems[0]
                    self.display()
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


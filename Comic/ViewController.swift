//
//  ViewController.swift
//  Comic
//
//  Created by Tin Vo on 9/25/15.
//  Copyright © 2015 Tin Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* An NSURL object represents a URL that can potentially contain the location of a
        resource on a remote server, the path of a local file on disk, or even an arbitrary
        piece of encoded data */
        let url = NSURL(string: "http://imgs.xkcd.com/comics/birthday.png")
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


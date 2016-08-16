//
//  DetailView.swift
//  FavoriteRSSReader
//
//  Created by TangZekun on 6/22/16.
//  Copyright © 2016 TangZekun. All rights reserved.
//

import UIKit

class DetailView: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var currentArticle :  Article?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = NSURL(string: currentArticle!.url)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)

    }


    


}

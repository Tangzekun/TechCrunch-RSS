//
//  ArticleTableView.swift
//  FavoriteRSSReader
//
//  Created by TangZekun on 6/22/16.
//  Copyright © 2016 TangZekun. All rights reserved.
//

import UIKit

private let reuseIdentifier = "articleCell"

class ArticleTableView: UITableViewController
{


    var articles = [Article]()
    var xmlParser : NSXMLParser!
    var currentArticle = Article()
    var parsedElement = ""
    var currentImageUrl = ""

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "articleCell")
        
        let urlString = NSURL(string: "http://techcrunch.com/feed/")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(urlString!)
        {
            (data,response,error) in
            if error != nil
            {
                return
                    print(error!.localizedDescription)
            }
            
            self.xmlParser = NSXMLParser (data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }

        
        task.resume()
        //self.tableView.registerClass(ArticleCell.self, forCellReuseIdentifier: "articleCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! ArticleCell
        
        cell.label1.text = article.title
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
        {
            if article.imageUrl.isEmpty
            {
                return
            }
            
            let imgUrl = NSURL(string : article.imageUrl)
            if imgUrl == nil
            {
                return
            }
            
            let imgData = NSData (contentsOfURL: imgUrl!)
            if imgData == nil
            {
                return
            }
            
            let currentImg = UIImage(data: imgData!)
            dispatch_async(dispatch_get_main_queue())
            {
                cell.image1.image = currentImg
            }

        }


        return cell
    }
 
    
    
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
//    {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//        let flowLayout = tableView?.tableViewLayout as! UITableViewFlowLayout
//        flowLayout.invalidateLayout()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail"
        {
            let controller = segue.destinationViewController as! DetailView
            let indexPath = tableView.indexPathForSelectedRow?.row
            controller.currentArticle = articles [indexPath!]

        }
    }
}
    
extension ArticleTableView : NSXMLParserDelegate
{
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
        // parsed element
    {
        if elementName == "item"
        {
            currentArticle = Article()
            return
        }
        
        if elementName == "title"
        {
            parsedElement = "title"
        }
        
        if elementName == "link"
        {
            parsedElement = "link"
        }
        
        if elementName == "media:content"
        {
            currentImageUrl = attributeDict ["url"] as String!
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
        // parsed Element (title) -> Techgranch is great
    {
        let str = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if parsedElement == "title"
        {
            if currentArticle.title.isEmpty
            {
                currentArticle.title = str
            }
        }
        
        if parsedElement == "link"
        {
            if currentArticle.url.isEmpty
            {
                currentArticle.url = str
            }
        }
        
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
        // current article
    {
        if elementName != "item"
        {
            return
        }
        
        currentArticle.imageUrl = currentImageUrl
        articles.append(currentArticle)
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.tableView!.reloadData()
        }
    }
}

    
//extension ArticleTableView
//{
//
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("showDetail", sender: indexPath)
//    }
//}



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



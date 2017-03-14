//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by dhara.patel on 09/03/17.
//  Copyright © 2017 SA. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var IBlblPopularity: UILabel!
    @IBOutlet weak var IBlblName: UILabel!
    @IBOutlet weak var IBimgView: UIImageView!
    var arrayData =  [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        IBimgView.isUserInteractionEnabled = true
        IBimgView.addGestureRecognizer(tapGesture)
         self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
         webserviceCall()
        // Do any additional setup after loading the view from its nib.
    }
    func imgTapped(){
        let imgUrl = NSURL(string: "http://image.tmdb.org/t/p/w500//\(self.arrayData[0].value(forKey: "poster_path")!)") as! URL
        let shareDefault = UserDefaults(suiteName: "group.com.extensiondemo")
        shareDefault?.set(imgUrl, forKey: "imgPhoto")
        //shareDefault?.set(IBlblPopularity.text, forKey: "popularity")
        shareDefault?.synchronize()
        let url = URL.init(string: "widget://")
        self.extensionContext?.open(url!, completionHandler: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact{
            UIView.animate(withDuration: 0.25, animations: {
                self.preferredContentSize = maxSize
            })
        }else if activeDisplayMode == .expanded{
            UIView.animate(withDuration: 0.25, animations: {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 350)
            })
        }
    }
    func webserviceCall(){
        let url = URL(string: "http://api.themoviedb.org/3/tv/popular?api_key=6a50b17d75490848034c3d61545b0a2a")
        let request = URLRequest(url: url!)
        let urlsession = URLSession.shared
        let datatask =  urlsession.dataTask(with: request as URLRequest) { (data, response, erroe) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                if let blogs = json["results"] as? [AnyObject]{
                    self.arrayData = blogs
                    print(self.arrayData)
                    DispatchQueue.main.async {
                        if let name = self.arrayData[0].value(forKey: "name") {
                           self.IBlblName.text = "\(name)"
                         }
//                       let iUrl = URL(string: "http://image.tmdb.org/t/p/w500//\(self.arrayData[0].value(forKey: "poster_path")!)")
//                        if let imgUrl = iUrl  {
//                           self.IBimgView.sd_setImage(with: imgUrl)
//                        }
                        if let url = NSURL(string: "http://image.tmdb.org/t/p/w500//\(self.arrayData[0].value(forKey: "poster_path")!)") {
                            if let data = NSData(contentsOf: url as URL) {
                                self.IBimgView.image = UIImage(data: data as Data)
                            }        
                        }
                        if let popularity = self.arrayData[0].value(forKey: "first_air_date"){
                            self.IBlblPopularity.text = "\(popularity)"
                        }
                    }
                }
            }
            catch
            {
                print("error serializing JSON: \(error)")
            }
        }
        datatask.resume()
    }
}
                 

//
//  ViewController.swift
//  WidgetDemo
//
//  Created by dhara.patel on 09/03/17.
//  Copyright © 2017 SA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var IBimgView: UIImageView!
    @IBOutlet weak var IBlblName: UILabel!
      var arrayData =  [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
       //webserviceCall()
        let shareDefault = UserDefaults(suiteName: "group.com.extensiondemo")
        let imgPhoto = shareDefault?.url(forKey: "imgPhoto")
        if let imgUrl = imgPhoto  {
            self.IBimgView.sd_setImage(with: imgUrl)
        }
        //let imgPhoto = shareDefault?.url(forKey: "imgPhoto")
        //IBimgView.image = UIImage(named: imgMoviePhoto!)
        let pop = shareDefault?.string(forKey: "popularity")
        IBlblName.text = pop
        shareDefault?.synchronize()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        let url = URL(string: "http://image.tmdb.org/t/p/w500//\(self.arrayData[0].value(forKey: "poster_path")!)")
                                if let imgUrl = url  {
                                        self.IBimgView.sd_setImage(with: imgUrl)
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


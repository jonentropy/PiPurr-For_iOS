//
//  ViewController.swift
//  PiPurr
//
//  Created by Tristan Linnell on 31/03/2017.
//  Copyright © 2017 Tris Linnell. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String, _ spinner: UIActivityIndicatorView) {
        print("Getting \(urlString)")
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            defer {
                DispatchQueue.main.async(execute: { () -> Void in
                    //self.isHidden = false
                    spinner.isHidden = true
                })
            }

            if error != nil {
                print(error ?? "erre")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}


class ViewController: UIViewController {


    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var buttonContainer: UIStackView!
    
    var fullscreen = false
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load default settings
        
        UserDefaults.standard.register(defaults: [String : Any]())
        
        //allow the image to be clicked
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //full screen it
        print("clicked!")
        fullscreen = !fullscreen
        
        buttonContainer.isHidden = fullscreen
    }
    
    
    @IBAction func liveClicked(_ sender: Any) {
        doServerCommand(endpoint: "cats.jpeg", imageView: image)
     }

  
    @IBAction func detectedClicked(_ sender: Any) {
        doServerCommand(endpoint: "pir.jpeg", imageView: image)
    }

    
    @IBAction func meowClicked(_ sender: Any) {
        doServerCommand(endpoint: "sound")
    }
    
    
    @IBAction func feedClicked(_ sender: Any) {
        doServerCommand(endpoint: "feed")
    }
    
    
    func doServerCommand(endpoint: String, imageView: UIImageView? = nil) {
        let server = userDefaults.string(forKey: "location_preference")
        if (server?.isEmpty)! {
            print("No server set, so doing nothing");
            return;
        }
        
        if ((imageView) != nil) {
            imageView!.image = nil
            spinner.isHidden = false
            imageView!.imageFromServerURL(urlString: "\(server!)/\(endpoint)", spinner);
        } else {
            URLSession.shared.dataTask(with: NSURL(string: "\(server!)/\(endpoint)")! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error ?? "erre")
                    return
                }
            }).resume()
        }
    }
    
    
}


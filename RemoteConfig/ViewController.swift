//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Антон on 24.04.2022.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    var remoteConfig = RemoteConfig.remoteConfig()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        remoteConfig.fetchAndActivate { (status, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if status != .error {
                    if let stringURL = self.remoteConfig["background_image_stringURL"].stringValue {
                        print("SUCCESS: \(stringURL)")
                        self.imageView.load(stringURL: stringURL)
                    }
                }
            }
        }
    }
}

extension UIImageView {
    
    func load(stringURL: String) {
        if let url = URL(string: stringURL) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
                
            }
        }
    }
}

//
//  AvatarViewController.swift
//  trackerVS
//
//  Created by Home on 08.06.2022.
//

import UIKit

final class AvatarViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapCameraButton(_ sender: Any) {
        
    }
}

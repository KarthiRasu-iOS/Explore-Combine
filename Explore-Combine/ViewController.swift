//
//  ViewController.swift
//  Explore-Combine
//
//  Created by Karthi Rasu on 30/11/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    
    //MARK: - Property Wrapper
    
    @Published var isShareEnabled : Bool = false
    private var switchSubscriber: AnyCancellable?
    
    //MARK: - Outlets
    
    @IBOutlet weak var shareProfileSwitch : UISwitch!
    @IBOutlet weak var saveChangesBtn : UIButton!


    override func viewDidLoad() {
        
        switchSubscriber = $isShareEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: saveChangesBtn)
    }
    
    //MARK: - Switch Action Button
    
    @IBAction func didSwitchChange(_ sender: UISwitch) {
        isShareEnabled = sender.isOn
    }
}


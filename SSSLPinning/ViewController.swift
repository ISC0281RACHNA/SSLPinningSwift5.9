//
//  ViewController.swift
//  DeSuperChat
//
//  Created by Rachna on 26/12/23.
//

import UIKit

class ViewController: UIViewController {
    let apiChatKey = "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"

    @IBOutlet weak var callBtn: UIButton!
    override func viewDidLoad()  {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
    }
    
    
    @IBAction func callAPI(_ sender: Any) {
        Task {
//            async let result1 =  try await PokemonService.shared.sendMessage()  //multiple API call with async let with async await
         //    let result2 =  try await PokemonService.shared.getMessage()
          //  print(result2.message!)
            
            try await URLSessionPinningDelegate.shared.call()
            //callBtn.titleLabel?.text = result2.status!
        }
        
    }
}

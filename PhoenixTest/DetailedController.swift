//
//  DetailedController.swift
//  PhoenixTest
//
//  Created by Jake Humphrey on 11/5/16.
//  Copyright © 2016 Jake Humphrey. All rights reserved.
//

import UIKit

class DetailedController: UIViewController {

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personMessage: UILabel!
    @IBOutlet weak var personDateTime: UILabel!
    
    var t_personName = "<name>"
    var t_personMessage = "..."
    var t_personDateTime: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personName.text = t_personName
        personMessage.text = t_personMessage
        personDateTime.text = timeStringFromUnixTime(unixTime: t_personDateTime)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date as Date)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        closeDetails()
    }
    @IBAction func SwipedOut(_ sender: Any) {
        closeDetails()
    }
    
    
    func closeDetails() {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }

    

}

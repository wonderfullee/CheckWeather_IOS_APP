//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by zhihao li on 2/16/19.
//  Copyright © 2019 zhihao li. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {
    var delegate: ChangeCityProtocol?

    @IBOutlet weak var text_city: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func channgCity_button_press(_ sender: UIButton) {
        let cityName = text_city.text!
        delegate?.changeCityFunc(cityName: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back_button_press(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

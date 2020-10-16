//
//  FirstLaunchViewController.swift
//  Futbolico
//
//  Created by Albert Mercadé on 04/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class FirstLaunchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var teamPickerView: UIPickerView!
    
    var selectedTeamID: Int!
    let keyIDs:[Int] = Array(Constants.teams.keys).sorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.isEnabled = false
        saveButton.layer.cornerRadius = 5
        
        teamPickerView.layer.cornerRadius = 8
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.teams.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if row > 0 {
            let teamName = Constants.teams[keyIDs[row-1]]!["name"]!
            let teamTLA = Constants.teams[keyIDs[row-1]]!["tla"]!
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 25, height: 25))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: teamTLA)
            
            let label = UILabel(frame: CGRect(x: 30, y: 2.5, width: pickerView.bounds.width - 60, height: 30))
            label.text = teamName
            label.font = label.font.withSize(20)
            
            let labelWidth = label.intrinsicContentSize.width
            let totalWidth = labelWidth + 25 + 5
            
            let viewXPos = (pickerView.bounds.width - totalWidth)/2
            let view = UIView(frame: CGRect(x: viewXPos, y: 0, width: totalWidth, height: 35))
            
            view.addSubview(imageView)
            view.addSubview(label)
            
            return view
        }
        
        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
            selectedTeamID = keyIDs[row-1]
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        UserDefaults.standard.set(selectedTeamID, forKey: "favouriteTeamID")
    }
}

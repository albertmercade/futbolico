//
//  TeamPickerViewController.swift
//  Futbolico
//
//  Created by Albert Mercadé on 10/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class TeamPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var teamPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let keyIDs:[Int] = Array(Constants.teams.keys).sorted()
    var selectedTeamID : Int!
    var firstSelection: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupColorTheme()
        saveButton.isEnabled = false
        
        let favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
        let row = keyIDs.firstIndex(of: favouriteTeamID)!
        teamPicker.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func setupColorTheme() {
        let color = UserDefaults.standard.string(forKey: "ColorTheme")
        switch color {
            case "Yellow":
                self.saveButton.tintColor = UIColor(named: "Yellow")
                self.cancelButton.tintColor = UIColor(named: "Yellow")
            case "Orange":
                self.saveButton.tintColor = .orange
                self.cancelButton.tintColor = .orange
            case "Red":
                self.saveButton.tintColor = .red
                self.cancelButton.tintColor = .red
            case "Blue":
                self.saveButton.tintColor = UIColor(named: "Blue")
                self.cancelButton.tintColor = UIColor(named: "Blue")
            case "Green":
                self.saveButton.tintColor = UIColor(named: "Green")
                self.cancelButton.tintColor = UIColor(named: "Green")
            default:
                self.saveButton.tintColor = self.view.tintColor
                self.cancelButton.tintColor = self.view.tintColor
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let teamName = Constants.teams[keyIDs[row]]!["name"]!
        let teamTLA = Constants.teams[keyIDs[row]]!["tla"]!
        
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if firstSelection {
            saveButton.isEnabled = true
            firstSelection = false
        }
        
        selectedTeamID = keyIDs[row]
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromTeamPickerSave", sender: self)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromTeamPickerCancel", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromTeamPickerSave" {
            UserDefaults.standard.set(selectedTeamID, forKey: "favouriteTeamID")
        }
    }

}

//
//  SettingsViewController.swift
//  Futbolico
//
//  Created by Albert Mercadé on 25/06/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var favouriteTeamButton: UIButton!
    @IBOutlet weak var teamButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var colorPickerControl: UISegmentedControl!
    
    var favouriteTeamID: Int! {
        didSet {
            let teamCrest = UIImage(named: Constants.teams[favouriteTeamID]!["tla"]!)?.resizeImage(height: 30).withRenderingMode(.alwaysOriginal)
            favouriteTeamButton.setImage(teamCrest, for: .normal)
            favouriteTeamButton.setTitle(Constants.teams[favouriteTeamID]!["shortName"]!, for: .normal)
            favouriteTeamButton.layer.cornerRadius = 8
            teamButtonWidth.constant = favouriteTeamButton.intrinsicContentSize.width + 35
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
        
        setupColorPicker()
        setupColorTheme()
    }
    
    private func setupColorPicker() {
        let color = UserDefaults.standard.string(forKey: "ColorTheme")
        switch color {
            case "Yellow":
                colorPickerControl.selectedSegmentIndex = 1
            case "Orange":
                colorPickerControl.selectedSegmentIndex = 2
            case "Red":
                colorPickerControl.selectedSegmentIndex = 3
            case "Blue":
                colorPickerControl.selectedSegmentIndex = 4
            case "Green":
                colorPickerControl.selectedSegmentIndex = 5
            default:
                colorPickerControl.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func colorThemeChanged(_ sender: UISegmentedControl) {
        let color = sender.selectedSegmentIndex
        switch color {
        case 1:
            UserDefaults.standard.set("Yellow", forKey: "ColorTheme")
        case 2:
            UserDefaults.standard.set("Orange", forKey: "ColorTheme")
        case 3:
            UserDefaults.standard.set("Red", forKey: "ColorTheme")
        case 4:
            UserDefaults.standard.set("Blue", forKey: "ColorTheme")
        case 5:
            UserDefaults.standard.set("Green", forKey: "ColorTheme")
        default:
            UserDefaults.standard.set("Default", forKey: "ColorTheme")
        }
        
        setupColorTheme()
    }
    
    private func setupColorTheme() {
        let color = UserDefaults.standard.string(forKey: "ColorTheme")
        switch color {
            case "Yellow":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Yellow")
                self.favouriteTeamButton.tintColor = UIColor(named: "Yellow")
            case "Orange":
                self.tabBarController?.tabBar.tintColor = .orange
                self.favouriteTeamButton.tintColor = .orange
            case "Red":
                self.tabBarController?.tabBar.tintColor = .red
                self.favouriteTeamButton.tintColor = .red
            case "Blue":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Blue")
                self.favouriteTeamButton.tintColor = UIColor(named: "Blue")
            case "Green":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Green")
                self.favouriteTeamButton.tintColor = UIColor(named: "Green")
            default:
                self.tabBarController?.tabBar.tintColor = self.view.tintColor
                self.favouriteTeamButton.tintColor = self.view.tintColor
        }
    }
    
    @IBAction func unwindFromTeamPickerSave(_ segue: UIStoryboardSegue) {
        favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: Constants.teams[favouriteTeamID]!["tla"]!)?.resizeImage(height: 25).withRenderingMode(.alwaysOriginal)
    }
    
    @IBAction func unwindFromTeamPickerCancel(_ segue: UIStoryboardSegue) {
        
    }
}


//
//  ClasificacionViewController.swift
//  Futbolico
//
//  Created by Albert Mercadé on 26/06/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit

class StandingsViewController: UITableViewController {
    private let refreshCont = UIRefreshControl()
    
    var standing: Table!
    var loadedStanding: Bool = false
    var favouriteTeamID: Int!
    var keyIDs:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
        
        self.tableView.refreshControl = refreshCont
        self.refreshCont.addTarget(self, action: #selector(refeshStandings), for: .valueChanged)
        
        standingsRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupColorTheme()
        
        if self.favouriteTeamID != UserDefaults.standard.integer(forKey: "favouriteTeamID") && loadedStanding {            
            self.favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
        }
        
        self.tableView.reloadData()
    }
    
    private func setupColorTheme() {
        let color = UserDefaults.standard.string(forKey: "ColorTheme")
        switch color {
            case "Yellow":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Yellow")
            case "Orange":
                self.tabBarController?.tabBar.tintColor = .orange
            case "Red":
                self.tabBarController?.tabBar.tintColor = .red
            case "Blue":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Blue")
            case "Green":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Green")
            default:
                self.tabBarController?.tabBar.tintColor = self.view.tintColor
        }
    }
    
    @objc private func refeshStandings() {
        standingsRequest()
    }
    
    func standingsRequest() {
        self.refreshCont.beginRefreshing()
        
        let session = RequestSession()
        let url = "https://api.football-data.org/v2/competitions/PD/standings"
        let headers = ["X-Auth-Token": "ab3c360dacbc4a9fa7cca1e3d11b0f6e"]
        session.requestAPI(url: url, headers: headers,  completionHandler: {data in
            var result: Standing!
            do{
                let decoder = JSONDecoder()
                result = try decoder.decode(Standing.self, from: data)
            } catch {
                fatalError("json failed")
            }
            self.standing = result.standings[0]
            self.loadedStanding = true
            
            for team in self.standing.table {
                self.keyIDs.append(team.team.id)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshCont.endRefreshing()
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadedStanding {
            return self.standing.table.count + 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let color = UserDefaults.standard.string(forKey: "ColorTheme")
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsTitleTableViewCell", for: indexPath) as? StandingsTitleTableViewCell else {
                fatalError("The dequed cell is not an instance of StandingTableViewCell")
            }
            
            switch color {
                case "Yellow":
                    cell.playedGamesLabel.textColor = UIColor(named: "YellowTextColor")
                    cell.goalDifferenceLabel.textColor = UIColor(named: "YellowTextColor")
                    cell.pointsLabel.textColor = UIColor(named: "YellowTextColor")
                case "Orange":
                    cell.playedGamesLabel.textColor = UIColor(named: "OrangeTextColor")
                    cell.goalDifferenceLabel.textColor = UIColor(named: "OrangeTextColor")
                    cell.pointsLabel.textColor = UIColor(named: "OrangeTextColor")
                case "Red":
                    cell.playedGamesLabel.textColor = UIColor(named: "RedTextColor")
                    cell.goalDifferenceLabel.textColor = UIColor(named: "RedTextColor")
                    cell.pointsLabel.textColor = UIColor(named: "RedTextColor")
                case "Blue":
                    cell.playedGamesLabel.textColor = UIColor(named: "BlueTextColor")
                    cell.goalDifferenceLabel.textColor = UIColor(named: "BlueTextColor")
                    cell.pointsLabel.textColor = UIColor(named: "BlueTextColor")
                case "Green":
                    cell.playedGamesLabel.textColor = UIColor(named: "GreenTextColor")
                    cell.goalDifferenceLabel.textColor = UIColor(named: "GreenTextColor")
                    cell.pointsLabel.textColor = UIColor(named: "GreenTextColor")
                default:
                    cell.playedGamesLabel.textColor = UIColor(named: "DefaultTextColor")
                    cell.goalDifferenceLabel.textColor = UIColor(named: "DefaultTextColor")
                    cell.pointsLabel.textColor = UIColor(named: "DefaultTextColor")
            }
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingTableViewCell", for: indexPath) as? StandingTableViewCell else {
                fatalError("The dequed cell is not an instance of StandingTableViewCell")
            }
            
            let row = indexPath.row - 1
            let teamId = standing.table[row].team.id
            
            cell.positionLabel.text = String(standing.table[row].position)
            cell.crestImage.image = UIImage(named: Constants.teams[teamId]!["tla"]!)
            cell.teamNameLabel.text = Constants.teams[teamId]!["shortName"]
            cell.playedGamesLabel.text = String(standing.table[row].playedGames)
            
            switch color {
                case "Yellow":
                    cell.positionLabel.textColor = UIColor(named: "YellowTextColor")
                case "Orange":
                    cell.positionLabel.textColor = UIColor(named: "OrangeTextColor")
                case "Red":
                    cell.positionLabel.textColor = UIColor(named: "RedTextColor")
                case "Blue":
                    cell.positionLabel.textColor = UIColor(named: "BlueTextColor")
                case "Green":
                    cell.positionLabel.textColor = UIColor(named: "GreenTextColor")
                default:
                    cell.positionLabel.textColor = UIColor(named: "DefaultTextColor")
            }
            
            let gd = standing.table[row].goalDifference
            if gd > 0 {
                cell.goalDiffLabel.text = "+" + String(gd)
            }
            else {
                cell.goalDiffLabel.text = String(gd)
            }
            
            cell.pointsLabel.text = String(standing.table[row].points)
            
            if row == keyIDs.firstIndex(of: favouriteTeamID) {
                cell.backgroundColor = UIColor(named: "HighlightedColor")
            }
            else {
                cell.backgroundColor = UIColor(named: "StandingsCellColor")
            }
            
            return cell
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You selected team \(standing.table[indexPath.row].team.name)")
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LatestNewsViewController.swift
//  Futbolico
//
//  Created by Albert Mercadé on 25/06/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import UIKit
import SafariServices

class LatestNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var matchesTableView: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var matchesTableHeight: NSLayoutConstraint!
    @IBOutlet weak var newsTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var latestNewsLabel: UILabel!
    
    private let refreshCont = UIRefreshControl()
    
    var favouriteTeamID: Int!
    var numCellsMatch: Int = 0
    var numCellsNews: Int = 0
    
    var upcomingMatches: Matches!
    var finishedMatch: Matches!
    var liveMatch: Matches!
    
    var teamArticles: Articles!
    var articleImages: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.        
        self.favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
        
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: Constants.teams[favouriteTeamID]!["tla"]!)?.resizeImage(height: 25).withRenderingMode(.alwaysOriginal)
        
        self.mainScrollView.refreshControl = refreshCont
        self.refreshCont.addTarget(self, action: #selector(refreshMatchesAndNews), for: .valueChanged)
        self.refreshMatchesAndNews()
        
        self.matchesTableView.layer.cornerRadius = 8
        self.newsTableView.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupColorTheme()
        if favouriteTeamID != UserDefaults.standard.integer(forKey: "favouriteTeamID") {
            self.favouriteTeamID = UserDefaults.standard.integer(forKey: "favouriteTeamID")
            
            self.refreshMatchesAndNews()
        }
    }
    
    private func setupColorTheme() {
        let color = UserDefaults.standard.string(forKey: "ColorTheme")
        switch color {
            case "Yellow":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Yellow")
                self.matchesLabel.textColor = UIColor(named: "YellowTextColor")
                self.latestNewsLabel.textColor = UIColor(named: "YellowTextColor")
            case "Orange":
                self.tabBarController?.tabBar.tintColor = .orange
                self.matchesLabel.textColor = UIColor(named: "OrangeTextColor")
                self.latestNewsLabel.textColor = UIColor(named: "OrangeTextColor")
            case "Red":
                self.tabBarController?.tabBar.tintColor = .red
                self.matchesLabel.textColor = UIColor(named: "RedTextColor")
                self.latestNewsLabel.textColor = UIColor(named: "RedTextColor")
            case "Blue":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Blue")
                self.matchesLabel.textColor = UIColor(named: "BlueTextColor")
                self.latestNewsLabel.textColor = UIColor(named: "BlueTextColor")
            case "Green":
                self.tabBarController?.tabBar.tintColor = UIColor(named: "Green")
                self.matchesLabel.textColor = UIColor(named: "GreenTextColor")
                self.latestNewsLabel.textColor = UIColor(named: "GreenTextColor")
            default:
                self.tabBarController?.tabBar.tintColor = self.view.tintColor
                self.matchesLabel.textColor = UIColor(named: "DefaultTextColor")
                self.latestNewsLabel.textColor = UIColor(named: "DefaultTextColor")
        }
    }
    
    @objc private func refreshMatchesAndNews() {
        self.refreshCont.beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: self.mainScrollView.contentOffset.y - self.refreshCont.frame.size.height)
        self.mainScrollView.setContentOffset(offsetPoint, animated: true)
        matchesAndNewsRequests()
    }
    
    func matchesAndNewsRequests() {
        let session = RequestSession()
        
        let group = DispatchGroup()
        
        var url = "https://api.football-data.org/v2/teams/" + String(favouriteTeamID) + "/matches?status=FINISHED"
        let headers = ["X-Auth-Token": "ab3c360dacbc4a9fa7cca1e3d11b0f6e"]
        group.enter()
        session.requestAPI(url: url, headers: headers, completionHandler: {data in
            var result = self.decodeMatchesFromData(data: data)
            
            let finishedLeagueMatches = Array(result.matches.filter({$0.competition.id == 2014})) as [Match]
            
            if finishedLeagueMatches.isEmpty {
                result.matches = []
            }
            else {
                result.matches = [finishedLeagueMatches.last!] as [Match]
            }
            
            self.finishedMatch = result
            
            group.leave()
        })
        
        url = "https://api.football-data.org/v2/teams/" + String(favouriteTeamID) + "/matches?status=LIVE"
        group.enter()
        session.requestAPI(url: url, headers: headers, completionHandler: {data in
            var result = self.decodeMatchesFromData(data: data)
            
            result.matches = Array(result.matches.filter({$0.competition.id == 2014})) as [Match]
            
            self.liveMatch = result
            
            group.leave()
        })
        
        url = "https://api.football-data.org/v2/teams/" + String(favouriteTeamID) + "/matches?status=SCHEDULED"
        group.enter()
        session.requestAPI(url: url, headers: headers, completionHandler: {data in
            var result = self.decodeMatchesFromData(data: data)
            
            let matchesFiltered = result.matches.filter({$0.competition.id == 2014}) as [Match]
            result.matches = Array(matchesFiltered.prefix(5))
            
            self.upcomingMatches = result
            
            group.leave()
        })
        
        url = "https://gnews.io/api/v3/search?q=" + Constants.teams[favouriteTeamID]!["name"]! + "&lang=es&country=es&max=10&token=1c3fd9111e616c5f237277692af6bd80"
        group.enter()
        session.requestAPI(url: url, headers: [:], completionHandler: {data in
            let result = self.decodeArticlesFromData(data: data)

            self.teamArticles = result
            self.articleImages = []
            
            for article in self.teamArticles.articles {
                let image = self.getImage(img: article.image)
                self.articleImages.append(image)
            }

            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            self.numCellsMatch = min(5, self.finishedMatch.matches.count + self.liveMatch.matches.count + self.upcomingMatches.matches.count)
            self.matchesTableHeight.constant = 45.0 * CGFloat(self.numCellsMatch)
            self.numCellsNews = self.teamArticles.articles.count
            self.newsTableHeight.constant = 80.0 * CGFloat(self.numCellsNews)
            self.matchesTableView.reloadData()
            self.newsTableView.reloadData()
            
            self.refreshCont.endRefreshing()
        }
    }
    
    private func getImage(img: String?) -> UIImage? {
        if let imageUrl = img, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    private func decodeMatchesFromData(data: Data) -> Matches {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Matches.self, from: data)
            return result
        } catch {
            fatalError("json failed")
        }
    }
    
    private func decodeArticlesFromData(data: Data) -> Articles {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Articles.self, from: data)
            return result
        } catch {
            fatalError("json failed")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.matchesTableView {
            return self.numCellsMatch
        }
        if tableView == self.newsTableView {
            return self.numCellsNews
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        if tableView == self.matchesTableView, let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath) as? MatchTableViewCell {
            return setupMatchTableViewCell(cell: cell, indexPath: indexPath)
        }
        else if tableView == self.newsTableView, let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell {
            return setupArticleTableViewCell(cell: cell, indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
    private func setupMatchTableViewCell(cell: MatchTableViewCell, indexPath: IndexPath) -> MatchTableViewCell {
        var match: Match!
        var teamId1: Int!
        var teamId2: Int!
        var offsetUpcoming = 0
        if !finishedMatch.matches.isEmpty {
            offsetUpcoming += 1
        }
        if !liveMatch.matches.isEmpty {
            offsetUpcoming += 1
        }
        
        cell.liveGifImage.isHidden = true
        cell.timeLabel.isHidden = true
        
        if indexPath.row == 0 && !finishedMatch.matches.isEmpty {
            cell.backgroundColor = UIColor(named: "FinishedMatchCellColor")
            match = finishedMatch.matches[0]
            teamId1 = match.homeTeam.id
            teamId2 = match.awayTeam.id
        }
        else if (indexPath.row == 0 && finishedMatch.matches.isEmpty && !liveMatch.matches.isEmpty) ||
            (indexPath.row == 1 && !liveMatch.matches.isEmpty && !finishedMatch.matches.isEmpty) {
            match = liveMatch.matches[0]
            teamId1 = match.homeTeam.id
            teamId2 = match.awayTeam.id
            
            cell.liveGifImage.animationImages = [
                UIImage(named: "live1")!,
                UIImage(named: "live2")!
            ]
            cell.liveGifImage.animationDuration = 1.0
            cell.liveGifImage.animationRepeatCount = 0
            cell.liveGifImage.startAnimating()
            cell.liveGifImage.isHidden = false
        }
        else {
            let index = indexPath.row - offsetUpcoming
            match = upcomingMatches.matches[index]
            teamId1 = match.homeTeam.id
            teamId2 = match.awayTeam.id
        }
        
        cell.crestImage1.image = UIImage(named: Constants.teams[teamId1]!["tla"]!)
        cell.teamNameLabel1.text = Constants.teams[teamId1]!["shortName"]
        
        cell.crestImage2.image = UIImage(named: Constants.teams[teamId2]!["tla"]!)
        cell.teamNameLabel2.text = Constants.teams[teamId2]!["shortName"]
        
        if (indexPath.row == 0 && !finishedMatch.matches.isEmpty) ||
            (indexPath.row == 0 && finishedMatch.matches.isEmpty && !liveMatch.matches.isEmpty) ||
            (indexPath.row == 1 && !liveMatch.matches.isEmpty && !finishedMatch.matches.isEmpty) {
            let homeGoals = match.score!.fullTime.homeTeam!
            let awayGoals = match.score!.fullTime.awayTeam!
            cell.scoreLabel.text = String(homeGoals) + " - " + String(awayGoals)
            cell.scoreLabel.font = UIFont.systemFont(ofSize: 17)
        }
        else {
            let (date, time) = toLocalTimeAndDate(utcTime: match.utcDate)
            cell.scoreLabel.font = UIFont.systemFont(ofSize: 14)
            cell.scoreLabel.text = date

            cell.timeLabel.text = time
            cell.timeLabel.isHidden = false
        }
        
        return cell
    }
    
    private func toLocalTimeAndDate(utcTime: String) -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: utcTime)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM HH:mm"
        
        let localTime = dateFormatter.string(from: dt!)
        let splitDateTime = localTime.components(separatedBy: " ")
        
        return (splitDateTime[0], splitDateTime[1])
    }
    
    private func setupArticleTableViewCell(cell: ArticleTableViewCell, indexPath: IndexPath) -> ArticleTableViewCell{
        let article = teamArticles.articles[indexPath.row]
        
        cell.articleTitleLabel.text = article.title

        if let image = self.articleImages[indexPath.row] {
            cell.articleImage.image = image
            cell.articleImage.isHidden = false
        }
        else {
            cell.articleImage.isHidden = true
        }
        
        cell.newsProviderLabel.text = article.source.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showSafariVC(for: teamArticles.articles[indexPath.row].url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

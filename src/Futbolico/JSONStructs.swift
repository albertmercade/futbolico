//
//  JSONStructs.swift
//  Futbolico
//
//  Created by Albert Mercadé on 02/07/2020.
//  Copyright © 2020 Albert Mercadé. All rights reserved.
//

import Foundation

struct Standing : Codable {
    var standings: [Table]
}

struct Table : Codable {
    struct Position : Codable {
        struct Team : Codable {
            var id: Int
            var name: String
            var crestUrl: String
        }
        
        var team: Team
        var position: Int
        var points: Int
        var playedGames: Int
        var won: Int
        var draw: Int
        var lost: Int
        var goalDifference: Int
        var goalsFor: Int
        var goalsAgainst: Int
    }
    
    var table: [Position]
}

struct Matches : Codable {
    var matches : [Match]
}

struct Match : Codable{
    struct Team : Codable{
        var id: Int
    }
    struct Score : Codable {
        struct FullTimeScore : Codable{
            var homeTeam: Int?
            var awayTeam: Int?
        }
        var fullTime: FullTimeScore
    }
    struct Competition: Codable {
        var id: Int
    }
    var utcDate: String
    var homeTeam: Team
    var awayTeam: Team
    var score: Score?
    var competition: Competition
}

struct Articles: Codable {
    var articles: [Article]
}

struct Article: Codable {
    struct Source: Codable {
        var name: String
    }
    var title: String
    var url: String
    var image: String?
    var source: Source
}

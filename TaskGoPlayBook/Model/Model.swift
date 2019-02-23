//
//  Model.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 21/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import Foundation

enum SearchScopeVal: String
{
    case Tournament = "Tournament"
    case Ground = "Ground"
    case Team = "Team"
    case Players = "Players"
    
    func Description() -> String
    {
        switch self
        {
        case .Tournament: return "Take part in exciting tournaments near you or follow them live"
        case .Ground: return "Discover Grounds nearby your location"
        case .Team: return "Create your own teams or join teams over goplaybook and grow"
        case .Players: return "Follow top players and fiends and keep yourself updated with their activities"
        }
    }
}

struct TournamentData: Codable
{
    var data: [Tournament]
    let last_page: Int
    let status: Bool
}

struct PlayerData: Codable
{
    var data: [Player]
    let last_page: Int
    let status: Bool
}

struct TeamData: Codable
{
    let data: [Team]
    let last_page: Int
    let status: Bool
}

struct GroundData: Codable
{
    var data: [Ground]
    var last_page: Int
    var status: Bool
}
struct Tournament: Codable
{
    let sport: String
    let status: String
    let name: String
    let logo: String?
    let tournament_id: Int
    let city: String
    
}

struct Ground: Codable
{
    let image: String?
    let city: String
    let status: String
    let id: Int
    let name: String
    
}

struct Team: Codable
{
    let city: String
    let team_pic: String?
    let name: String
    let sport: String?
    let id: Int
}

struct Player: Codable
{
    
    let player_pic: String?
    let city: String
    let name: String
    let sport: String
    let id: Int
    
}


//
//  Network.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 21.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation

class Network {
    
    let data_url = "0fcddb9b.ngrok.io"
    
    var ranking : [RankingItem] = []
    
    struct UserItem : Decodable{
        let score: Int
        let username: String
    }
    struct RankingItem : Decodable {
        let rank: Int
        let user: UserItem
    }
    
    init() {
        //init connections...
        
        self.load_data()
    }
    
    func init_with_dummy_data(){
        ranking.append(RankingItem(rank: 1, user: UserItem(score: 3000, username: "tim")))
        ranking.append(RankingItem(rank: 2, user: UserItem(score: 1234, username: "hans")))
        ranking.append(RankingItem(rank: 3, user: UserItem(score: 7355, username: "simon")))
        ranking.append(RankingItem(rank: 4, user: UserItem(score: 2355, username: "peter")))
        ranking.append(RankingItem(rank: 5, user: UserItem(score: 6533, username: "lorenz")))
    }
    
    func refresh(){
        
    }
    
    func load_data(){
        if let url = URL(string: data_url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(RankingItem.self, from: data)
                     
                    } catch let error {
                        
                    }
                }
            }.resume()
        } else {
            print("Error in URL?")
        }
    }
}


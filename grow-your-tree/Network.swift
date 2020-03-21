//
//  Network.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 21.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation

class Network {
    
    let data_url = "http://f89b7efa.ngrok.io"
    
    var ranking = RankingItem(users: [:])
    var dataReady : Bool = false
    
    struct UserItem : Decodable{
        let score: Int
        let username: String
        let location: [Double] // lat and long
    }
    struct RankingItem : Decodable {
        let users: [String:UserItem]
    }
    
    init() {
        //init connections...
        getHttpData(urlAddress: data_url)
    }

    func getRanking(places: Int) -> [UserItem]{
        var returnItem = [UserItem](repeating: UserItem(score: 0, username: "", location: [0,0]), count: places)
        
        for (rank, user) in self.ranking.users {
            var r = Int(rank) ?? 0
            r -= 1
            if (r > (places - 1)){
                continue
            }
            returnItem[r] = user
        }
        
        return returnItem
    }
    
    func findScore(userName:String) -> Int{
        for (_, user) in self.ranking.users{
            if user.username == userName {
                return user.score
            }
        }
        
        return 0
    }
    
    func isDataReady() -> Bool {
        return dataReady
    }
    
    func updateScore(userName:String, score:Int) {
        let surl = String(format: "%@/%@/%@", data_url, userName, String(score))
        let url = URL(string: surl)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    func getHttpData(urlAddress : String)
    {
        // Asynchronous Http call to your api url, using NSURLSession:
        guard let url = URL(string: urlAddress) else
        {
            print("Url conversion issue.")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    var d = String(data: data!, encoding: .utf8)
                    d = "{\"users\":" + d! + "}"
                    
                    self.ranking = try decoder.decode(RankingItem.self, from: (d?.data(using: .utf8)!)!)
                    print(self.ranking)
                    self.dataReady = true
                } catch {
                    print(error)
                    // Something went wrong
                }
            }
            else if error != nil
            {
                print(error)
            }
        }).resume()
    }
}


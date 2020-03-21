//
//  Network.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 21.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation

class Network {
    
    let data_url = "http://508212e7.ngrok.io"
    
    var ranking = RankingItem(users: [:])
    var dataReady : Bool = false
    
    struct UserItem : Decodable{
        let score: Int
        let username: String
        let location: String
    }
    struct RankingItem : Decodable {
        let users: [String:UserItem]
    }
    
    init() {
        //init connections...
        getHttpData(urlAddress: data_url)
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
                    
                    ranking = try decoder.decode(RankingItem.self, from: (d?.data(using: .utf8)!)!)
                    print(ranking)
                    
                    // Access specific key with value of type String
                    // let str = json["key"] as! String0
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


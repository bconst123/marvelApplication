//
//  APIManager.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import Foundation

class ApiManager {
    func createArrayFromAPI(urltocall: String, offset: Int,completion: @escaping (_ resulCal: MarvelModel?, _ error: Error?) -> Void) {
    
        guard let finalURL = URL(string: urltocall+String(offset)) else {
            print("Error: Cannot create URL from string")
            return
        }
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, error)
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, error)
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultCall = try decoder.decode(MarvelModel.self, from: responseData)
                return completion(resultCall, nil)
            } catch let error{
                return completion(nil, error)
            }
            
        }
        task.resume()
    }
}


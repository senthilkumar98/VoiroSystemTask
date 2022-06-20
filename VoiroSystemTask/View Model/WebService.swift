//
//  WebService.swift
//  VoiroSystemTask
//
//  Created by Senthil Kumar T on 20/06/22.
//

import UIKit

class WebService: NSObject {

    
    //MARK:- JSON PARSE
    func getResponse(urlString: String, oncompletion:@escaping ([MovieResponseEntity]) -> Void,
                     onerror:@escaping (Error) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
        print("URL--->>>",urlString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, resonse, error)in
            guard error == nil else {return}
            guard let dat = data else {return}
            do {
                let content = try JSONDecoder().decode([MovieResponseEntity].self, from: dat)
                oncompletion(content)
                
            } catch {
                onerror(error)
                print("Error--->>>",error)
            }
        }
        task.resume()
        
    }
}

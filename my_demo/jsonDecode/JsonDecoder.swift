//
//  JsonDecoder.swift
//  my_demo
//
//  Created by Class on 2022/4/10.
//

import Foundation

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func jsonfiledecode() -> results {
    
    let searchResponse: jsonObject = load("Livetube.json")
    let target = results(lightyear_list: searchResponse.result.lightyear_list, stream_list: searchResponse.result.stream_list)
    
    return target

}





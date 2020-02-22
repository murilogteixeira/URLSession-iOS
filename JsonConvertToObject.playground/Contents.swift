import Foundation
//
//var jsonString = """
//[
//    {
//        "name":"Murilo Teixeira",
//        "age":24,
//        "city":"brasilia"
//    },
//    {
//        "name":"Erilane Teixeira",
//        "age":23,
//        "city":"goias"
//    }
//]
//"""
////let jsonData = Data(jsonString.utf8)
//let jsonData = jsonString.data(using: .utf8)
//
//struct Person: Codable {
//    var name: String
//    var age: Int
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case age = "age"
//    }
//}
//
//
//do {
//    let people = try decoder.decode([Person].self, from: jsonData!)
//    print(people)
//    print(people[0].name)
//} catch {
//    print(error.localizedDescription)
//}

struct Results: Codable {
    let temp: Int
    let city: String

    private enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case city = "city_name"
    }
}

struct Tempo: Codable {
    let results: Results
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

let decoder = JSONDecoder()
let session = URLSession.shared
let task = session.dataTask(with: URL(string: "https://api.hgbrasil.com/weather?woeid=455819")!, completionHandler: { data, response, error in
    do {
        let tempo = try decoder.decode(Tempo.self, from: data!)
        print(tempo.results)
    } catch {
        print(error.localizedDescription)
    }
})

//task.resume()

let url = URL(string: "https://api-murilo.mybluemix.net/usuario/list")!
let taskGet = session.dataTask(with: url, completionHandler: { data, response, error in
    do {
        let contatos = try decoder.decode([String].self, from: data!)
        print(contatos)
    } catch {
        print(error.localizedDescription)
    }
})
//task.resume()

struct Usuario: Codable {
    let name: String
    let transferLimitUsed: Double
    let account: Conta
    let savings: Conta
}

struct Conta: Codable {
    var balance: Double
    var historic: [Transacao]
}

struct Transacao: Codable {
    let description: String
    let value: Double
    let date: String
}

let urlPost = URL(string: "https://api-murilo.mybluemix.net/usuario/search")!
var request = URLRequest(url: urlPost)
request.httpMethod = "POST"

request.setValue("appliucation/json", forHTTPHeaderField: "Content-Type")
request.setValue("Powered by Swift", forHTTPHeaderField: "X-Powered-By")

let json = [
    "name":"murilo"
]
let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
let taskPost = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
    do {
        if let data = data {
            let contatos = try decoder.decode(Usuario.self, from: data)
            print(contatos)
        }
    } catch {
        print("Erro: \(error.localizedDescription)")
    }
}

taskPost.resume()


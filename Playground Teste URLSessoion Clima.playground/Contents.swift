import UIKit

let session = URLSession.shared
let url = "https://api-murilo.mybluemix.net/"
let option = "usuario/list"
let prepareUrl = "\(url)\(option)"

let urlApi = URL(string: prepareUrl)!

let task = session.dataTask(with: urlApi) { data, response, error in
    // verifica se houve erro
    guard error == nil else {
        print("Ocorreu um erro. \(String(describing: error))")
        return
    }
    
    // verifica o status code da resposta
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        return
    }
    print("StatusCode: \(httpResponse.statusCode)")
    
    // verificar se a resposta é do tipo json
    guard let mime = response?.mimeType, mime == "application/json" else {
        print("Tipo MIME incorreto")
        return
    }
    
    // converte os dados da resposta do tipo binário para json
    var json: Any!
    do {
        json = try JSONSerialization.jsonObject(with: data!, options: [])

        if let dados = json as? [String:Any] {
            if let lista = dados["nomes"] as? [String] {
                print(lista)
            }
        }

    } catch {
        print("JSON error: \(error.localizedDescription)")
    }
}
task.resume()

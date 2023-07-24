import Foundation

class JsonPlaceHolderApiService: ApiService {
    let baseUrl = "https://jsonplaceholder.typicode.com"
        
    func get<T: Codable>(endpoint: Endpoint) async -> (T?, Error?) {
        // print("\n>>> ☁️ Cargando datos desde El Servidor.\n")
        do {
            guard let url = endpoint.buildUrl(baseUrl: baseUrl) else {
                return (
                    nil,
                    NSError(
                    domain: "API",
                    code: 0,
                    userInfo: [
                        NSURLErrorKey : "URL does not valid"
                    ]))
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let json = try JSONDecoder().decode(T.self, from: data)
            return (json, nil)
        } catch {
            return (nil, error)
        }
    }
}

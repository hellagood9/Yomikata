import Foundation

extension URLSession {
    func getData(from request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await data(for: request)

            guard let httpURLResponse = response as? HTTPURLResponse else {
                throw NetworkError.connectionFailed
            }

            guard (200...299).contains(httpURLResponse.statusCode) else {
                switch httpURLResponse.statusCode {
                case 401: throw NetworkError.unauthorized
                case 403: throw NetworkError.forbidden
                case 404: throw NetworkError.notFound
                default:
                    throw NetworkError.serverError(httpURLResponse.statusCode)
                }
            }

            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    func getJSON<T: Decodable>(from request: URLRequest, type: T.Type)
        async throws -> T
    {
        do {
            let data = try await getData(from: request)
            let decoder = JSONDecoder()

            return try decoder.decode(type, from: data)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed(error)
        }

    }
}

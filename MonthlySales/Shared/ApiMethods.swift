//
//  ApiMethods.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation

protocol ApiMethodsProtocol {
    func getSalesDataFor(startDate: Date, endDate: Date, completion: @escaping (Data?) -> Void)
    func fetchUserInfo(completion: @escaping ((user: String?, currencySymbol: String?)) -> Void)
    init(formatters: FormattersProtocol)
}

protocol ApiParserProtocol {
    func parseSalesData(_ data: Data) -> [Sale]
    init(formatters: FormattersProtocol)
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String { get }
}

final class ApiMethods: ApiMethodsProtocol {
    private let apiBaseURL = "https://api.appfigures.com"

    /*
     Get the clientKey on the AppFigures key manager: https://appfigures.com/developers/keys
     */
    private let clientKey = ""

    /*
     The authorizationKey must be base64 encoded in the format USERNAME:PASSWORD.
     Open Terminal and type (with *your* username/password, duh):
         echo -n 'USERNAME:PASSWORD' | base64
     This will return the base64 encoded string you need to paste here.
     */
    private let authorizationKey = ""

    /*
     Account Email. Required to fetch the currency.
     */
    private let userEmail = ""

    private let formatters: FormattersProtocol
    
    private func APIRequest(with method: String, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue(clientKey, forHTTPHeaderField: "X-Client-Key")
        request.addValue("Basic \(authorizationKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    init(formatters: FormattersProtocol) {
        self.formatters = formatters
        
        if clientKey.isEmpty || authorizationKey.isEmpty || userEmail.isEmpty {
            fatalError("clientKey, authorizationKey or userEmail is empty")
        }
    }

    func getSalesDataFor(startDate: Date, endDate: Date, completion: @escaping (Data?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

        guard var URL = URL(string: apiBaseURL + "/v2/reports/sales") else { return }
        let URLParams = ["start_date": formatters.fromDate(startDate),
                         "end_date": formatters.fromDate(endDate),
                         "include_inapps": "true",
                         "group_by": "dates"]
        
        URL = URL.appendingQueryParameters(URLParams)
        let request = APIRequest(with: "GET", url: URL)


        session.dataTask(with: request, completionHandler: { (data: Data?, _, error: Error?) -> Void in
            if error == nil {
                completion(data)
            } else {
                print("URL Session Task Failed: %@", error!.localizedDescription)
                completion(nil)
            }
        }).resume()
        session.finishTasksAndInvalidate()
    }

    private func getUserInfo(completion: @escaping (User?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

        guard let URL = URL(string: apiBaseURL + "/v2/users/\(userEmail)") else { return }
        let request = APIRequest(with: "GET", url: URL)

        session.dataTask(with: request, completionHandler: { (data: Data?, _, error: Error?) -> Void in
            if error == nil {
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let object = json as? [String: Any] else { return }

                    let user = try User(json: object)
                    completion(user)
                } catch let error {
                    print(error)
                    completion(nil)
                }
            } else {
                print("URL Session Task Failed: %@", error!.localizedDescription)
                completion(nil)
            }
        }).resume()
        session.finishTasksAndInvalidate()
    }

    private func getCurrencySymbol(iso: String, completion: @escaping (String?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

        guard let URL = URL(string: apiBaseURL + "/v2/data/currencies") else { return }
        let request = APIRequest(with: "GET", url: URL)

        session.dataTask(with: request, completionHandler: { (data: Data?, _, error: Error?) -> Void in
            if error == nil {
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let array = json as? [[String: Any]] else { return }

                    var currencies = [Currency]()

                    try array.forEach({
                        currencies.append(try Currency(json: $0))
                    })
                    completion(Currency.symbolForISO(iso, currencies: currencies))
                } catch let error {
                    print(error)
                    completion(nil)
                }
            } else {
                print("URL Session Task Failed: %@", error!.localizedDescription)
                completion(nil)
            }
        }).resume()
        session.finishTasksAndInvalidate()
    }

    func fetchUserInfo(completion: @escaping ((user: String?, currencySymbol: String?)) -> Void) {
        getUserInfo { [weak self] (user: User?) in
            
            if let iso = user?.currency {
                self?.getCurrencySymbol(iso: iso, completion: { (symbol: String?) in
                    completion((user: user?.name, currencySymbol: symbol))
                })
            } else {
                completion((user: user?.name, currencySymbol: nil))
            }
        }
    }
}

final class ApiParser: ApiParserProtocol {
    private let formatters: FormattersProtocol

    init(formatters: FormattersProtocol) {
        self.formatters = formatters
    }
    
    func parseSalesData(_ data: Data) -> [Sale] {
        var returnArray = [Sale]()

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let array = json as? [String: [String: Any]] else { return returnArray }
            
            for (_, obj) in array {
                let sale = try Sale(json: obj, formatters: formatters)
                if sale.date < formatters.today() && !formatters.isDateToday(sale.date) {
                    returnArray.append(sale)
                }
                
                returnArray = returnArray.sorted(by: { $0.date > $1.date })
            }
        } catch let error {
            print(error)
        }
        
        return returnArray
    }
}


extension Dictionary : URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary: Dictionary<String, String>) -> URL {
        let URLString: String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

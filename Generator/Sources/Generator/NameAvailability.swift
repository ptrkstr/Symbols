import Foundation

struct NameAvailability: Decodable {
    let symbols: [String: String]
    let year_to_release: [String: YearToRelease]
    
    func availability(for symbol: String) -> String {
        let year = symbols[symbol]!
        return String(describing: year_to_release[year]!)
    }
    
    func yearToRelease(for symbol: String) -> YearToRelease {
        let year = symbols[symbol]!
        return year_to_release[year]!
    }
}

struct YearToRelease: Decodable, CustomStringConvertible {
    let iOS: String
    let macOS: String
    let tvOS: String
    let watchOS: String
    
    var description: String {
        "@available(iOS \(iOS), macOS \(macOS), tvOS \(tvOS), watchOS \(watchOS), *)"
    }
}

import Foundation

import Foundation

enum DateUtils {
    static func parseDate(from dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    static func formatPublicationDates(
        startDate: Date,
        endDateString: String?,
        onlyYear: Bool = false
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // usa el idioma del device
        dateFormatter.dateFormat = onlyYear ? "yyyy" : "LLL yyyy"
        
        let startString = dateFormatter.string(from: startDate)
        
        if let endDateString = endDateString,
           let endDate = parseDate(from: endDateString) {
            let endString = dateFormatter.string(from: endDate)
            return "\(startString) - \(endString)"
        } else {
            return "\(startString) - " + "general.na".localized()
        }
    }
}

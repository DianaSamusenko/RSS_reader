//
//  NewsParser.swift
//  RSS_reader
//
//  Created by Diana Samusenka on 3.02.23.
//

import Foundation

struct RSSItem {
    var title: String
    var description: String
    var pubDate: String
    var imageURL: String?
    var link: String
}

final class NewsParser: NSObject {
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentPubDate = ""
    private var currentImageURL = ""
    private var currentLink = ""
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
    }
}

//MARK: - XMLParserDelegate

extension NewsParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentImageURL = ""
            currentLink = ""
        } else if currentElement == "enclosure" {
            if let urlString = attributeDict["url"] {
                currentImageURL += urlString
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string.replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: .whitespaces)
        case "description": currentDescription += string.replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: .whitespaces)
        case "pubDate": currentPubDate += string.replacingOccurrences(of: "\n", with: "")
        case "link": currentLink += string.replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: .whitespaces)
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: changeDateFormat(dateString: currentPubDate), imageURL: currentImageURL, link: currentLink)
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}

private extension NewsParser {
    func changeDateFormat(dateString: String) -> String {
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        currentDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = currentDateFormatter.date(from: dateString)

        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "HH:mm, d MMMM y"
        return newDateFormatter.string(from: date ?? Date())
    }
}

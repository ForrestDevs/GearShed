//
//  ItemDiaryRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemDiaryHistoryRowView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @ObservedObject var diary: ItemDiary
    
    var body: some View {
        Button {
            detailManager.selectedItemDiary = diary
            withAnimation {
                detailManager.secondaryTarget = .showItemDiaryDetail
            }
        } label: {
            
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(diary.gearlist.startDate?.monthDayYearDateText() ?? "").formatItemNameBlack()
                    Text("| ").formatItemNameBlack()
                    Text("\"\(diary.details)\"")
                        .formatDiaryDetails()
                        .lineLimit(1)
                }
            }
            .padding(.leading, 15)
            .padding(.top, 5)
            .padding(.bottom, 5)
        }
    }
}

struct RichText: View {

    struct Element: Identifiable {
        let id = UUID()
        let content: String
        let isBold: Bool

        init(content: String, isBold: Bool) {
            var content = content.trimmingCharacters(in: .whitespacesAndNewlines)

            if isBold {
                content = content.replacingOccurrences(of: "*", with: "")
            }

            self.content = content
            self.isBold = isBold
        }
    }

    let elements: [Element]

    init(_ content: String) {
        elements = content.parseRichTextElements()
    }

    var body: some View {
        var content = text(for: elements.first!)
        elements.dropFirst().forEach { (element) in
            content = content + self.text(for: element)
        }
        return content
    }
    
    private func text(for element: Element) -> Text {
        let postfix = shouldAddSpace(for: element) ? " " : ""
        if element.isBold {
            return Text(element.content + postfix)
                .fontWeight(.bold)
        } else {
            return Text(element.content + postfix)
        }
    }

    private func shouldAddSpace(for element: Element) -> Bool {
        return element.id != elements.last?.id
    }
    
}



extension String {

    /// Parses the input text and returns a collection of rich text elements.
    /// Currently supports asterisks only. E.g. "Save *everything* that *inspires* your ideas".
    ///
    /// - Returns: A collection of rich text elements.
    func parseRichTextElements() -> [RichText.Element] {
        let regex = try! NSRegularExpression(pattern: "\\*{1}(.*?)\\*{1}")
        let range = NSRange(location: 0, length: count)

        /// Find all the ranges that match the regex *CONTENT*.
        let matches: [NSTextCheckingResult] = regex.matches(in: self, options: [], range: range)
        let matchingRanges = matches.compactMap { Range<Int>($0.range) }

        var elements: [RichText.Element] = []

        // Add the first range which might be the complete content if no match was found.
        // This is the range up until the lowerbound of the first match.
        let firstRange = 0..<(matchingRanges.count == 0 ? count : matchingRanges[0].lowerBound)

        self[firstRange].components(separatedBy: " ").forEach { (word) in
            guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            elements.append(RichText.Element(content: String(word), isBold: false))
        }

        // Create elements for the remaining words and ranges.
        for (index, matchingRange) in matchingRanges.enumerated() {
            let isLast = matchingRange == matchingRanges.last

            // Add an element for the matching range which should be bold.
            let matchContent = self[matchingRange]
            elements.append(RichText.Element(content: matchContent, isBold: true))

            // Add an element for the text in-between the current match and the next match.
            let endLocation = isLast ? count : matchingRanges[index + 1].lowerBound
            let range = matchingRange.upperBound..<endLocation
            self[range].components(separatedBy: " ").forEach { (word) in
                guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                elements.append(RichText.Element(content: String(word), isBold: false))
            }
        }

        return elements
    }

    /// - Returns: A string subscript based on the given range.
    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}



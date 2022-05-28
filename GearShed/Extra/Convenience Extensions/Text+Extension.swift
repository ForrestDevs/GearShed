//
//  Text+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import SwiftUI

extension Text {
    // MARK: Page Header Titles
    func formatPageHeaderTitle() -> some View {
        self.font(.custom("HelveticaNeue", size: 16.5).bold())
    }
    // MARK: Stat Bar Fonts
    func formatStatBarTitle() -> some View {
        self.font(.custom("HelveticaNeue", size: 15))
    }
    func formatStatBarContent() -> some View {
        self.font(.custom("HelveticaNeue", size: 14))
    }
    // MARK: List Header Fonts
    func listHeaderTitle() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 16.5).bold())
    }
    // MARK: Diary Row Views
    func formatDiaryDetails() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 16.5).italic())
            .frame(alignment: .leading)
    }
    // MARK: Item Detail
    func formatDetailTitleGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 22).bold())
    }
    func formatDetailTitleBlack() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 22).bold())
    }
    func formatDetailsWPPBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 15))
    }
    func formatDetailDescriptionBlack() -> some View {
        self.foregroundColor(Color.theme.secondaryText)
            .font(.custom("HelveticaNeue", size: 15))
    }
    // MARK: Item Row View
    func formatEmptyTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 20))
    }
    func formatEntryTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 15.5))
            .bold()
    }
    func formatBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    func formatBlackTitle() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 18).bold())
    }
    func formatBlackSmall() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 15))
    }
    func formatBlackSub() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 15))
    }
    func formatIAPTitle() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 20).bold())
    }
    func formatIAPHeader() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    func formatIAPItems() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 16).bold())
    }
    func formatIAPFooter() -> some View {
        self.foregroundColor(Color.gray)
            .font(.custom("HelveticaNeue", size: 15))
    }
    func formatGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    func formatItemNameGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 16.5))
    }
    func formatItemNameBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 16.5))
    }
    func formatItemDetailDiaryHeader() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 18))
    }
    func formatItemWeightBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 13))
    }
    func formatItemPriceGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 13))
    }
    func formatItemDetailsGrey() -> some View {
        self.foregroundColor(Color.theme.secondaryText)
            .font(.custom("HelveticaNeue", size: 13))
    }
    func formatGreen17Gradi() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    func formatGreenTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 18).bold())
    }
    func formatGreenSmall() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    func formatNoColorSmall() -> some View {
        self.font(.custom("HelveticaNeue", size: 16.5))
    }
    func formatNoColorLarge() -> some View {
        self.font(.custom("HelveticaNeue", size: 17).bold())
    }
}

extension TextField {
    func formatBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    func formatBlackTitle() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 20).bold())
    }
    func formatBlackSmall() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    func formatBlackSub() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 12))
    }
    func formatGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    func formatGreenTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 20).bold())
    }
    func formatGreenSmall() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    func formatNoColorSmall() -> some View {
        self.font(.custom("HelveticaNeue", size: 12).bold())
    }
    func formatNoColorLarge() -> some View {
        self.font(.custom("HelveticaNeue", size: 17).bold())
    }
}

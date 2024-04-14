//
//  HelpPopoverView.swift
//  HomeyPad
//
//  Created by Brian McAuliff Mulloy on 4/14/24.
//

import SwiftUI

struct HelpPopoverView: View {
    
    static let mamiIcon: String = "paintbrush.pointed.fill"
    
    var body: some View {
        Text("Homey Pad")
        Divider()
        ScrollView(.vertical) {
            Text("Legend")
            Text("Icons: Consonance-Dissonance")
            ForEach(ConsonanceDissonance.allCases, id: \.self) { codi in
                HStack {
                    AnyShape(codi.symbol)
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(.white)
                    Text(codi.label.capitalized)
                }
            }
            Text("Colors: Major-Minor")
            ForEach(MajorMinor.allCases, id: \.self) { mami in
                HStack {
                    Image(systemName: HelpPopoverView.mamiIcon)
                        .foregroundColor(Color(mami.color))
                    Text(mami.label.capitalized)
                }
            }
            Text("Intervals")
            ForEach(IntervalClass.allCases, id: \.self) { intervalClass in
                HStack {
                    AnyShape(intervalClass.interval.consonanceDissonance.symbol)
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(Color(intervalClass.interval.majorMinor.color))
                    Text(intervalClass.interval.shorthand)
                    Text(intervalClass.interval.label)
                }
            }
        }
    }
}


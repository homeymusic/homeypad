import Foundation
import SwiftUI
import Keyboard
import Tonic
import Controls
import AVFoundation

struct SwiftUIIntervals: View {
    var keysPerRow: Int
    var body: some View {
        let extraColsPerSide : Int = Int(floor(CGFloat(keysPerRow - 13) / 2))
        VStack(spacing: 0) {
            HStack(spacing: 1) {
                ForEach(-extraColsPerSide...(12+extraColsPerSide), id: \.self) { col in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                        Text(intervalLabel(col))
                            .font(.custom("Monaco", size: 20))
                            .scaledToFit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(homeyForegroundColor(col, reverseHomeColor: false))
                            .padding(2)
                    }
                }
            }
        }
    }
}

struct SwiftUIHomeSelector: View {
    var keysPerRow: Int
    var tonicPitchClass: Int
    var buttonTapped: (Pitch, CGPoint) -> Void = { _, _ in }
    var showClassicalSelector: Bool
    var showMonthsSelector: Bool
    var showPianoSelector: Bool
    var selectorTapped: (Int) -> Void = { _ in }
    
    // safety valve
    func safeMIDI(_ p: Int) -> Int {
        if p > -1 && p < 128 {
            return p
        } else {
            return p % 12
        }
    }
    
    var body: some View {
        let extraColsPerSide : Int = Int(floor(CGFloat(keysPerRow - 13) / 2))
        VStack(spacing: 0) {
            HStack(spacing: 1) {
                ForEach(-extraColsPerSide...(12+extraColsPerSide), id: \.self) { col in
                    if mod(col, 12) == 0 {
                        SelectorStyle(col: col,
                                      showClassicalSelector: showClassicalSelector,
                                      showMonthsSelector: showMonthsSelector,
                                      showPianoSelector: showPianoSelector,
                                      tonicPitchClass: tonicPitchClass)
                    } else {
                        Button {
                            selectorTapped(tonicPitchClass + col)
                        } label: {
                            SelectorStyle(col: col,
                                          showClassicalSelector: showClassicalSelector,
                                          showMonthsSelector: showMonthsSelector,
                                          showPianoSelector: showPianoSelector,
                                          tonicPitchClass: tonicPitchClass)
                        }
                    }
                }
            }
        }
    }
}

struct SwiftUIKeyboard: View {
    var octaveCount: Int
    var keysPerRow: Int
    var tonicPitchClass: Int
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch)->Void
    let initialC: Int = 60
    let row: Int
    let col: Int
    
    var body: some View {
        Keyboard(layout: .dualistic(octaveCount: octaveCount, keysPerRow: keysPerRow, tonicPitchClass: tonicPitchClass, initialC: initialC),
                 noteOn: noteOn, noteOff: noteOff){ pitch, isActivated, row, col in
            SwiftUIKeyboardKey(pitch: pitch,
                               isActivated: isActivated,
                               row: row,
                               col: col,
                               labelType: .symbol,
                               tonicPitchClass: tonicPitchClass,
                               initialC: initialC)
        }.cornerRadius(5)
    }
}

struct SwiftUIKeyboardKey: View {
    @State var MIDIKeyPressed = [Bool](repeating: false, count: 128)
    
    var pitch : Pitch
    var isActivated : Bool
    let row: Int
    let col: Int
    let labelType: LabelType
    var tonicPitchClass : Int
    let initialC: Int
    
    var body: some View {
        VStack{
            IntervallicKey(pitch: pitch,
                           isActivated: isActivated,
                           row: row,
                           col: col,
                           labelType: labelType,
                           initialC: 48,
                           tonicPitchClass: tonicPitchClass,
                           tonicColor: Color(red: 102 / 255, green: 68 / 255, blue: 51 / 255),
                           perfectColor: Color(red: 243 / 255, green: 221 / 255, blue: 171 / 255),
                           majorColor: Default.majorColor,
                           minorColor: Default.minorColor,
                           tritoneColor: Default.tritoneColor,
                           keyColor: Default.homeComplementColor,
                           tonicKeyColor: Default.homeColor,
                           flatTop: true,
                           isActivatedExternally: MIDIKeyPressed[pitch.intValue])
        }.onReceive(NotificationCenter.default.publisher(for: .MIDIKey), perform: { obj in
            if let userInfo = obj.userInfo, let info = userInfo["info"] as? UInt8, let val = userInfo["bool"] as? Bool {
                self.MIDIKeyPressed[Int(info)] = val
            }
        })
    }
}

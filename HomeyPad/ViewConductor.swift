import SwiftUI

class ViewConductor: ObservableObject {
    
    var allPitches = [Pitch]()

    init() {
        for midi: Int8 in 0...127 {
            allPitches.append(Pitch(midi))
        }
    }

    @Published var layoutChoice: LayoutChoice = .symmetric  {
        willSet { allPitchesNoteOff() }
    }

    func allPitchesNoteOff() {
        self.allPitches.forEach {pitch in
            pitch.noteOff()
        }
    }

    @Published var paletteChoice: [LayoutChoice: PaletteChoice] = [
        .isomorphic: .subtle,
        .symmetric:  .loud,
        .piano:      .ebonyIvory,
        .guitar:     .subtle
    ]
    
    @Published var showTonicPicker: Bool = false
                
    @Published var tonicMIDI: Int = 60

    @Published var lowMIDI: [LayoutChoice: Int] = [
        .isomorphic: 57,
        .symmetric:  53,
        .piano:      53,
        .guitar:     40
    ]
    
    @Published var highMIDI: [LayoutChoice: Int] = [
        .isomorphic: 75,
        .symmetric:  79,
        .piano:      79,
        .guitar:     86
    ]
    
    var tonicPitch: Pitch {
        self.allPitches[self.tonicMIDI]
    }
    
    var pitches: ArraySlice<Pitch> {
        return allPitches[lowMIDI[self.layoutChoice]!...highMIDI[self.layoutChoice]!]
    }
    
}

//
//  SettingsView.swift
//
//  Created by Brian McAuliff Mulloy on 9/12/23.
//

import SwiftUI
import AudioKit

struct PlayView: View {
    @Environment(\.dismiss) var dismiss
    var viewConductor: ViewConductor
    let midiPlayer: MIDIPlayer
    
    var midiCallback = MIDICallbackInstrument()
    
    func initSequencer(nowPlaying: any View, filename: String, songTonic: Int) {
        let midiCallback = MIDICallbackInstrument()
        self.midiPlayer.nowPlaying = nowPlaying
        midiCallback.callback = { status, note, velocity in
            let midiNote = UInt8(Default.initialC - songTonic + viewConductor.tonicPitchClass + Int(note))
            if status == 144 {
                viewConductor.conductor.instrument.play(noteNumber: midiNote, velocity: 127, channel: 0)
                NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": true])
            } else if status == 128 {
                viewConductor.conductor.instrument.stop(noteNumber: midiNote, channel: 0)
                NotificationCenter.default.post(name: .MIDIKey, object: nil, userInfo: ["info": midiNote, "bool": false])
            }
        }
        midiPlayer.sequencer.loadMIDIFile(fromURL: Bundle.main.url(forResource: filename, withExtension: "mid", subdirectory: "Examples")!)
        midiPlayer.sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
        midiPlayer.sequencer.enableLooping()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Example Tunes")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 10)
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        HStack {
                            Text("Example Melodies")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        Button {
                            dismiss()
                            viewConductor.keysPerRow = 13
                            viewConductor.octaveCount = 1
                            initSequencer(nowPlaying: HStack(spacing: 4) {
                                Text("Twinkle Twinkle Little Star")
                                    .foregroundColor(Default.majorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }, filename: "twinkle_twinkle_little_star", songTonic: 48)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Twinkle Twinkle Little Star")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            dismiss()
                            viewConductor.keysPerRow = 13
                            viewConductor.octaveCount = 1
                            initSequencer(nowPlaying: HStack(spacing: 4) {
                                Text("Seven Nation Army")
                                    .foregroundColor(Default.minorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }, filename: "seven_nation_army", songTonic: 52)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Seven Nation Army")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                        }
                        Button {
                            dismiss()
                            viewConductor.keysPerRow = 23
                            viewConductor.octaveCount = 1
                            initSequencer(nowPlaying: HStack(spacing: 4) {
                                Text("Happy Birthday")
                                    .foregroundColor(Default.majorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }, filename: "happy_birthday", songTonic: 60)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("Happy Birthday")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            dismiss()
                            viewConductor.keysPerRow = 23
                            viewConductor.octaveCount = 1
                            initSequencer(nowPlaying: HStack(spacing: 4) {
                                Text("May Your Soul Rest")
                                    .foregroundColor(Default.minorColor)
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }, filename: "may_your_soul_rest", songTonic: 52)
                            midiPlayer.play()
                        } label: {
                            HStack {
                                Text("May Your Soul Rest")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                        }
                    }
                    Divider()
                        .padding(5)
                    Group {
                        HStack {
                            Text("Example Harmonies")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Ionian (Major)")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Phrygian")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Mixolydian")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Aeolian (Natural Minor)")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Harmonic Minor")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Dorian Down")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Dorian Up")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Lydian")
                                    .foregroundColor(Default.majorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "multiply.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(Default.majorColor)
                                    Image(systemName: "greaterthan.square")
                                        .foregroundColor(Default.majorColor)
                                }
                            }
                        }
                        Button {
                            print("play example")
                        } label: {
                            HStack {
                                Text("Locrian")
                                    .foregroundColor(Default.minorColor)
                                    .underline()
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "multiply.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "minus.square.fill")
                                        .foregroundColor(Default.minorColor)
                                    Image(systemName: "lessthan.square")
                                        .foregroundColor(Default.minorColor)
                                }
                            }
                        }
                    }
                }
                .padding([.trailing, .leading, .bottom], 10)
            } // ScrollView
        }
    }
}

import SwiftUI
import AVFoundation
import Keyboard
import Tonic
import Controls

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewConductor = ViewConductor()
    @State private var showingSettingsPopover = false
    @State private var showingHelpPopover = false
    @State private var showingPlayPopover = false
    @State private var playerState = PlayerState.stopped
    @State private var nowPlaying: any View = Text("")

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 0) {
                            // The help view
                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        self.showingHelpPopover.toggle()
                                    }) {
                                        Image(systemName: "house").foregroundColor(.white)
                                    }.popover(isPresented: $showingHelpPopover,
                                              content: {
                                        HelpView()
                                            .presentationCompactAdaptation(.none)
                                    })
                                }
                            }
                            .padding(.leading, 10)
                            // The play view
                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        self.showingPlayPopover.toggle()
                                        if playerState != .stopped {
                                            viewConductor.conductor.sequencer.stop()
                                            playerState = .stopped
                                        }
                                    }) {
                                        Image(systemName: "headphones").foregroundColor(.white)
                                    }.popover(isPresented: $showingPlayPopover,
                                              content: {
                                        PlayView(viewConductor: viewConductor, playerState: $playerState, nowPlaying: $nowPlaying)
                                            .presentationCompactAdaptation(.none)
                                    })
                                }
                            }
                            .padding(.leading, 10)
                            // Stop play pause buttons
                            if playerState == .playing || playerState == .paused {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            viewConductor.conductor.sequencer.rewind()
                                            viewConductor.simpleSuccess()
                                        }) {
                                            Image(systemName: "backward.end.circle.fill").foregroundColor(.white)
                                        }
                                        Button(action: {
                                            viewConductor.conductor.sequencer.stop()
                                            playerState = .stopped
                                            viewConductor.simpleSuccess()
                                        }) {
                                            Image(systemName: "stop.circle.fill").foregroundColor(.white)
                                        }
                                        .padding(.leading, 5)
                                        if playerState == .playing {
                                            Button(action: {
                                                viewConductor.conductor.sequencer.stop()
                                                playerState = .paused
                                                viewConductor.simpleSuccess()
                                            }) {
                                                Image(systemName: "pause.circle.fill").foregroundColor(.white)
                                            }
                                            .padding(.leading, 5)
                                        } else if playerState == .paused {
                                            Button(action: {
                                                viewConductor.conductor.sequencer.play()
                                                playerState = .playing
                                                viewConductor.simpleSuccess()
                                            }) {
                                                Image(systemName: "play.circle.fill").foregroundColor(.white)
                                            }
                                            .padding(.leading, 5)
                                        }
                                        AnyView(nowPlaying)
                                            .padding(.leading, 8)
                                    }
                                }
                                .padding(.leading, 16)
                            }
                            Spacer()
                            //the customize view
                            VStack(alignment: .trailing) {
                                HStack {
                                    Button(action: {
                                        self.showingSettingsPopover.toggle()
                                    }) {
                                        ZStack {
                                            Image(systemName: "ellipsis").foregroundColor(.white)
                                            Image(systemName: "square").foregroundColor(.clear)
                                        }
                                    }.popover(isPresented: $showingSettingsPopover,
                                              content: {
                                        CustomizeView(showClassicalSelector: $viewConductor.showClassicalSelector,
                                                      showMonthsSelector: $viewConductor.showMonthsSelector,
                                                      showPianoSelector: $viewConductor.showPianoSelector,
                                                      showIntervals: $viewConductor.showIntervals,
                                                      octaveCount: $viewConductor.octaveCount,
                                                      keysPerRow: $viewConductor.keysPerRow,
                                                      playerState: $playerState,
                                                      conductor: viewConductor.conductor)
                                        .presentationCompactAdaptation(.none)
                                    })
                                }
                            }
                            .padding(.trailing, 10)
                        }
                        Spacer()
                    }
                    // keyboard
                    VStack(spacing: 0) {
                        // home selector
                        Spacer()
                        if (viewConductor.showClassicalSelector || viewConductor.showMonthsSelector || viewConductor.showPianoSelector) {
                            // The tonic selector
                            SwiftUIHomeSelector(keysPerRow: viewConductor.keysPerRow, tonicPitchClass: viewConductor.tonicPitchClass,
                                                showClassicalSelector: viewConductor.showClassicalSelector,
                                                showMonthsSelector: viewConductor.showMonthsSelector, showPianoSelector: viewConductor.showPianoSelector, selectorTapped: viewConductor.selectHome)
                            .aspectRatio(CGFloat(viewConductor.keysPerRow), contentMode: .fit)
                            .padding(.bottom, 7)
                        }
                        // The main dualistic keyboard
                        SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, keysPerRow: viewConductor.keysPerRow, tonicPitchClass: viewConductor.tonicPitchClass, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff, row: 0, col: 0)
                            .frame(maxHeight: CGFloat(viewConductor.octaveCount) * 4.5 * (proxy.size.width / CGFloat(viewConductor.keysPerRow)))
                        if (viewConductor.showIntervals) {
                            // The intervals display
                            SwiftUIIntervals(keysPerRow: viewConductor.keysPerRow)
                                .aspectRatio(CGFloat(viewConductor.keysPerRow), contentMode: .fit)
                                .padding(.bottom, 5)
                        }
                        Spacer()
                    }
                    .padding([.top, .bottom], 25)
                }
            }.onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    if !viewConductor.conductor.engine.avEngine.isRunning {
                        try? viewConductor.conductor.instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
                        try? viewConductor.conductor.engine.start()
                    }
                } else if newPhase == .background {
                    viewConductor.conductor.engine.stop()
                }
            }.onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { event in
                switch event.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt {
                case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
                    reloadAudio()
                case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
                    reloadAudio()
                default:
                    break
                }
            }.onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { event in
                guard let info = event.userInfo,
                      let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                    return
                }
                if type == .began {
                    self.viewConductor.conductor.engine.stop()
                } else if type == .ended {
                    guard let optionsValue =
                            info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                        return
                    }
                    if AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                        reloadAudio()
                    }
                }
            }
            .onDisappear() { self.viewConductor.conductor.engine.stop() }
            .environmentObject(viewConductor.midiManager)
            .statusBar(hidden: true)
        }
        .padding(.top, 25)
    }
    func reloadAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewConductor.conductor.engine.avEngine.isRunning {
                try? viewConductor.conductor.instrument.loadInstrument(at: Bundle.main.url(forResource: "Sounds/YDP-GrandPiano-20160804", withExtension: "sf2")!)
                viewConductor.conductor.start()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

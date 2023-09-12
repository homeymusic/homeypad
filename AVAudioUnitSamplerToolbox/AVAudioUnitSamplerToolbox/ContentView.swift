import SwiftUI
import AVFoundation
import Keyboard
import Tonic
import Controls

struct ContentView: View {
    @StateObject var viewConductor = ViewConductor()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        Text("Settings")
                        Stepper(LocalizedStringKey(stringLiteral: "Octaves \(viewConductor.octaveCount)"), value: $viewConductor.octaveCount, in: 1...8, step: 1)
//                        Button {
//                            // Do something
//                        } label: {
//                            Label("Share", systemImage: "square.and.arrow.up")
//                        }
                    } label: {
                        Image(systemName: "gear").foregroundColor(.gray)
                    }
                }
                Spacer()
                SwiftUITonicSelector(noteOff: viewConductor.noteOff)
                SwiftUIKeyboard(octaveCount: viewConductor.octaveCount, noteOn: viewConductor.noteOn(pitch:point:), noteOff: viewConductor.noteOff)
                Spacer()
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !viewConductor.conductor.engine.isRunning {
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
    }
    func reloadAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewConductor.conductor.engine.isRunning {
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

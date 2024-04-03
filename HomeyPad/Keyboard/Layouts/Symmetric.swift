import SwiftUI

struct Symmetric<Content>: View where Content: View {
    let content: (Pitch, Pitch) -> Content
    var model: KeyboardModel
    var pitches: ArraySlice<Pitch>
    var tonicPitch: Pitch
    
    var body: some View {
        HStack(spacing: 0) {
            let dP5 = pitches.startIndex
            let dtt = pitches.index(after: dP5)
            let dP4 = pitches.index(after: dtt)
            let dm3 = pitches.index(after: dP4)
            let dM3 = pitches.index(after: dm3)
            let dm2 = pitches.index(after: dM3)
            let dM2 = pitches.index(after: dm2)
            let P1 = pitches.index(after: dM2)
            let m2 = pitches.index(after: P1)
            let M2 = pitches.index(after: m2)
            let m3 = pitches.index(after: M2)
            let M3 = pitches.index(after: m3)
            let P4 = pitches.index(after: M3)
            let tt = pitches.index(after: P4)
            let P5 = pitches.index(after: tt)
            let m6 = pitches.index(after: P5)
            let M6 = pitches.index(after: m6)
            let m7 = pitches.index(after: M6)
            let M7 = pitches.index(after: m7)
            let P8 = pitches.index(after: M7)
            let m9 = pitches.index(after: P8)
            let M9 = pitches.index(after: m9)
            let m10 = pitches.index(after: M9)
            let M10 = pitches.index(after: m10)
            let P11 = pitches.index(after: M10)
            let ttt = pitches.index(after: P11)
            let P12 = pitches.index(after: ttt)
            
            // below main
            KeyContainer(model: model,
                         pitch: pitches[dP5],
                         tonicPitch: tonicPitch,
                         content: content)
            KeyContainer(model: model,
                         pitch: pitches[dP4],
                         tonicPitch: tonicPitch,
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: pitches[dtt],
                                     tonicPitch: tonicPitch,
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[dM3],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[dm3],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[dM2],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[dm2],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            // main octave
            KeyContainer(model: model,
                         pitch: pitches[P1],
                         tonicPitch: tonicPitch,
                         content: content)
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[M2],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[m2],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[M3],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[m3],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: pitches[P4],
                         tonicPitch: tonicPitch,
                         content: content)
            KeyContainer(model: model,
                         pitch: pitches[P5],
                         tonicPitch: tonicPitch,
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: pitches[tt],
                                     tonicPitch: tonicPitch,
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[M6],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[m6],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[M7],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[m7],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: pitches[P8],
                         tonicPitch: tonicPitch,
                         content: content)
            // above main
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[M9],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[m9],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            VStack(spacing: 0){
                KeyContainer(model: model,
                             pitch: pitches[M10],
                             tonicPitch: tonicPitch,
                             content: content)
                KeyContainer(model: model,
                             pitch: pitches[m10],
                             tonicPitch: tonicPitch,
                             content: content)
            }
            KeyContainer(model: model,
                         pitch: pitches[P11],
                         tonicPitch: tonicPitch,
                         content: content)
            KeyContainer(model: model,
                         pitch: pitches[P12],
                         tonicPitch: tonicPitch,
                         content: content)
            .overlay() {
                GeometryReader { proxy in
                    let ttLength = tritoneLength(proxy.size)
                    ZStack {
                        KeyContainer(model: model,
                                     pitch: pitches[ttt],
                                     tonicPitch: tonicPitch,
                                     zIndex: 1,
                                     content: content)
                        .frame(width: ttLength, height: ttLength)
                    }
                    .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                }
            }
            
        }
        .clipShape(Rectangle())
    }
    
    func tritoneLength(_ proxySize: CGSize) -> CGFloat {
        return min(proxySize.height * 0.3125, proxySize.width * 1.0)
    }
    
}

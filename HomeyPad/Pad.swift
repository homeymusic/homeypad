enum Pad: String, CaseIterable, Identifiable {
    case isomorphic = "isomorphic"
    case symmetric = "symmetric"
    case piano = "piano"
    case guitar = "guitar"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
            case .isomorphic: return "rectangle.split.2x1"
            case .symmetric: return "rectangle.split.2x2"
            case .piano: return "pianokeys"
            case .guitar: return "guitars"
        }
    }
}
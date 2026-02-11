import SwiftUI

@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed

    var selectedDestination: Destination?
    var isShowingDetail = false

    // TODO: move this to a proper service
    var destinations: [Destination] = Destination.samples
}

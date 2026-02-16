import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        NavigationSplitView {
            DestinationListView()
        } detail: {
            if let dest = appModel.selectedDestination {
                DestinationDetailPanel(destination: dest)
            } else {
                ContentUnavailableView(
                    "Select a Destination",
                    systemImage: "globe.europe.africa",
                    description: Text("Choose a destination from the list to explore.")
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                HStack(spacing: 16) {
                    toggleImmersiveButton
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            await appModel.loadDestinations()
        }
    }

    @ViewBuilder
    private var toggleImmersiveButton: some View {
        Button {
            Task {
                switch appModel.immersiveSpaceState {
                case .open:
                    appModel.immersiveSpaceState = .inTransition
                    await dismissImmersiveSpace()
                case .closed:
                    appModel.immersiveSpaceState = .inTransition
                    let result = await openImmersiveSpace(id: appModel.immersiveSpaceID)
                    switch result {
                    case .opened:
                        appModel.immersiveSpaceState = .open
                    case .userCancelled, .error:
                        appModel.immersiveSpaceState = .closed
                    @unknown default:
                        appModel.immersiveSpaceState = .closed
                    }
                case .inTransition:
                    break
                }
            }
        } label: {
            Label(
                appModel.immersiveSpaceState == .open ? "Exit Globe" : "Explore Globe",
                systemImage: appModel.immersiveSpaceState == .open ? "xmark.circle" : "globe"
            )
        }
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .accessibilityHint(appModel.immersiveSpaceState == .open
            ? "Double-tap to close the immersive globe view"
            : "Double-tap to open an immersive 3D globe")
    }
}

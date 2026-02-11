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
                Text("Select a destination")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                HStack(spacing: 16) {
                    toggleImmersiveButton
                    // TODO: add filter/sort controls here
                }
                .padding(.horizontal, 20)
            }
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
    }
}

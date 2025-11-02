//
//  VideoPlayerView.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {

	@State private var isPlaying: Bool = false

	var body: some View {
		ZStack(alignment: .center) {
			Color.white
				.ignoresSafeArea()

			controlButtonsView
		}
	}

	var controlButtonsView: some View {
		HStack(alignment: .center) {
			MediaControlButton(systemName: "backward.fill") {
				seekBackward()
			}
			MediaControlButton(
				systemName: isPlaying ? "pause.fill" : "play.fill"
			) {
				togglePlaying()
			}
			MediaControlButton(systemName: "forward.fill") {
				seekForward()
			}
		}
	}
}

extension VideoPlayerView {

	func togglePlaying() {

	}

	func seekBackward() {

	}

	func seekForward() {

	}
}

#Preview {
    VideoPlayerView()
}

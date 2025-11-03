//
//  MediaControlButton.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import SwiftUI

struct MediaControlButton: View {

	var systemName: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Circle()
				.foregroundStyle(.clear)
				.overlay(content: {
					Image(systemName: systemName)
						.resizable()
						.padding(18)
						.tint(.white)
				})
				.clipShape(Circle())
				.glassEffect(.clear.interactive())
		}
	}
}

#Preview {
	MediaControlButton(
		systemName: "play") {
			print("button tapped")
		}
}

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
			Image(systemName:	systemName)
				.resizable()
				.scaledToFit()
				.tint(.white)
				.padding(12)
				.clipShape(Circle())
				.glassEffect()
				.background(.clear)
				.frame(width: 60, height: 60)
		}
	}
}

#Preview {
	MediaControlButton(
		systemName: "play") {
			print("button tapped")
		}
}

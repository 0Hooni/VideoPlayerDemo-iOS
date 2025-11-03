//
//  PlayTime.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import SwiftUI

struct PlayTimeText: View {
	@Binding var currentTime: TimeInterval
	@Binding var duration: TimeInterval

	var body: some View {
		HStack {
			Text(currentTime.toColonStyleString())
			Text("/")
			Text(duration.toColonStyleString())
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 12)
		.foregroundStyle(.white)
		.background(.black.opacity(0.8))
		.clipShape(.capsule)
		.glassEffect(.clear)
	}
}

#Preview {
	PlayTimeText(
		currentTime: .constant(13.0),
		duration: .constant(87.0)
	)
}

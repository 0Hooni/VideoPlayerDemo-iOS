//
//  SeekerBar.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import SwiftUI

struct SeekBar: View {

	@Binding var currentTime: TimeInterval
	@Binding var duration: TimeInterval
	let maxWidth: Double = 600
	let horizontalPadding: Double = 4

	var body: some View {
		ZStack {
			Color.black.opacity(0.6)
				.clipShape(.capsule)
				.frame(width: maxWidth + horizontalPadding * 2, height: 20)
				.overlay {
					let progress = duration > 0 ? (currentTime / duration) : 0
					
					HStack(spacing: 0) {
						Color.white
							.frame(width: maxWidth * progress)

						Spacer(minLength: 0)
					}
					.clipShape(.capsule)
					.padding(horizontalPadding)
				}
		}
		.glassEffect(.clear.interactive())
	}
}

#Preview {
	SeekBar(
		currentTime: .constant(8.0),
		duration: .constant(16.0)
	)
}

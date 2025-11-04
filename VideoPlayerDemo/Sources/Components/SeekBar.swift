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
	@Binding var bufferedTime: TimeInterval
	let maxWidth: Double = 600
	let horizontalPadding: Double = 4

	var body: some View {
		Color.black.opacity(0.6)
			.clipShape(.capsule)
			.frame(height: 20)
			.frame(maxWidth: maxWidth + horizontalPadding * 2)
			.overlay {
				GeometryReader { geometry in
					let availableWidth = geometry.size.width - (horizontalPadding * 2)
					let progress = duration > 0 ? (currentTime / duration) : 0
					let bufferedProgress = duration > 0 ? (bufferedTime / duration) : 0

					ZStack(alignment: .leading) {
						// 버퍼 진행 상태 표시
						HStack(spacing: 0) {
							Color.gray.opacity(0.5)
								.frame(width: availableWidth * bufferedProgress)
							Spacer(minLength: 0)
						}

						// 진행 상태 표시
						HStack(spacing: 0) {
							Color.white
								.frame(width: availableWidth * progress)
							Spacer(minLength: 0)
						}
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
		duration: .constant(16.0),
		bufferedTime: .constant(12.0)
	)
}

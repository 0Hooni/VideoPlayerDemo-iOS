//
//  VideoPlayerLayerView.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import SwiftUI
import AVFoundation

struct VideoPlayerLayerView: UIViewRepresentable {

	let player: AVPlayer

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .black

		let playerLayer = AVPlayerLayer(player: player)
		playerLayer.videoGravity = .resizeAspect
		playerLayer.frame = view.bounds

		view.layer.addSublayer(playerLayer)

		// Store playerLayer in context for updates
		context.coordinator.playerLayer = playerLayer

		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		context.coordinator.playerLayer?.frame = uiView.bounds
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	class Coordinator {
		var playerLayer: AVPlayerLayer?
	}
}

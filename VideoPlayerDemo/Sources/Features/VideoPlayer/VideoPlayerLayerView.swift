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
		let view = PlayerView(player: player)
		view.backgroundColor = .black
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {}
}

private class PlayerView: UIView {
	let playerLayer: AVPlayerLayer

	init(player: AVPlayer) {
		playerLayer = AVPlayerLayer(player: player)
		playerLayer.videoGravity = .resizeAspect
		super.init(frame: .zero)
		layer.addSublayer(playerLayer)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer.frame = bounds
	}
}

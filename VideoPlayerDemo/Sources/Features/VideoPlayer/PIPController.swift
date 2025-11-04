//
//  PIPController.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/4/25.
//

import AVKit

class PIPController: NSObject {
	private let instance: AVPictureInPictureController!
	private var pipPossibleObservation: NSKeyValueObservation?

	var onStateChange: ((Bool) -> Void)?
	var onPossibilityChange: ((Bool) -> Void)?

	init(with playerLayer: AVPlayerLayer) {
		instance = AVPictureInPictureController(playerLayer: playerLayer)

		super.init( )

		instance.delegate = self
		setupPIPPossibleObserver()
	}

	private func setupPIPPossibleObserver() {
		pipPossibleObservation = instance.observe(
			\.isPictureInPicturePossible,
			options: [.new, .initial]
		) { [weak self] controller, change in
			Task { @MainActor in
				self?.onPossibilityChange?(change.newValue ?? false)
			}
		}
	}

	deinit {
		pipPossibleObservation?.invalidate()
		pipPossibleObservation = nil
	}
}

// MARK: - PIP Controller utils
extension PIPController {
	func togglePIP() {
		if instance.isPictureInPictureActive {
			instance.stopPictureInPicture()
		} else {
			instance.startPictureInPicture()
		}
	}
}

// MARK: - PIP Controller Delegate
extension PIPController: AVPictureInPictureControllerDelegate {
	func pictureInPictureControllerDidStartPictureInPicture(
		_ pictureInPictureController: AVPictureInPictureController
	) {
		print("PIP did start")
		onStateChange?(true)
	}

	func pictureInPictureControllerDidStopPictureInPicture(
		_ pictureInPictureController: AVPictureInPictureController
	) {
		print("PIP did stop")
		onStateChange?(false)
	}

	func pictureInPictureController(
		_ pictureInPictureController: AVPictureInPictureController,
		failedToStartPictureInPictureWithError error: Error
	) {
		print("PIP failed to start with error: \(error.localizedDescription)")
		onStateChange?(false)
	}
}

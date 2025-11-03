//
//  VideoListViewModel.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import SwiftUI
import AVFoundation
import Combine

@MainActor
final class VideoListViewModel: ObservableObject {
	@Published var videos: [Video]
	@Published var thumbnails: [UUID: Data] = [:]
	@Published var durations: [UUID: TimeInterval] = [:]
	@Published var hlsInputText: String = ""

	init(videos: [Video]) {
		self.videos = videos
	}

	var localVideos: [Video] {
		videos.filter {
			if case .local = $0.source { return true }
			else { return false }
		}
	}

	var remoteVideos: [Video] {
		videos.filter {
			if case .remote = $0.source { return true }
			else { return false }
		}
	}

	/// 영상의 길이
	func loadDuration(for video: Video) async {
		guard let url = video.source.url else { return }

		let asset = AVURLAsset(url: url)

		do {
			let duration = try await asset.load(.duration)
			let seconds = CMTimeGetSeconds(duration)

			self.durations[video.id] = seconds
		} catch {
			print("Failed to load duration for video: \(video.title), error: \(error)")
		}
	}

	/// 영상의 가장 앞부분을 썸네일로 사용
	func loadThumbnail(for video: Video) async {
		guard let url = video.source.url else { return }

		let asset = AVURLAsset(url: url)
		let imageGenerator = AVAssetImageGenerator(asset: asset)
		imageGenerator.appliesPreferredTrackTransform = true

		do {
			let cgImage = try await imageGenerator.image(at: CMTime(value: 600, timescale: 600)).image
			let uiImage = UIImage(cgImage: cgImage)

			if let imageData = uiImage.pngData() {
				self.thumbnails[video.id] = imageData
			}
		} catch {
			print("Failed to generate thumbnail for video: \(video.title), error: \(error)")
		}
	}

	func playHLSVideo() { }
}

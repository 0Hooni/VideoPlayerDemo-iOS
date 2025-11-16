//
//  VideoSectionFeature.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/17/25.
//

import Foundation
import AVFoundation

import ComposableArchitecture

@Reducer
struct VideoSectionFeature {

	@ObservableState
	struct State: Equatable {
		var videos: [Video]
	}

	enum Action {
		case videoChanged(videos: [Video])

		case loadThubmnail(for: Video)
		case loadDuration(for: Video)
		case loadingThumbnailFinished(for: Video, data: Data)
		case loadingThumbnailFailed
		case loadingDurationFinished(for: Video, duration: TimeInterval)
		case loadingDurationFailed
	}

	var body: some Reducer<State, Action> {
		Reduce { state, action in
			switch action {
			case .videoChanged(let videos):
				state.videos = videos
				return .none

			case .loadThubmnail(let video):
				if video.thumbnail != nil { return .none }
				return .run { send in
					if let data = try await loadThumbnail(for: video) {
						return await send(.loadingThumbnailFinished(for: video, data: data))
					} else {
						return await send(.loadingThumbnailFailed)
					}
				} catch: { error, send in
					await send(.loadingThumbnailFailed)
				}

			case .loadDuration(let video):
				if video.duration != nil { return .none }
				return .run { send in
					if let duration = try await loadDuration(for: video) {
						return await send(.loadingDurationFinished(for: video, duration: duration))
					} else {
						return await send(.loadingDurationFailed)
					}
				} catch: { error, send in
					await send(.loadingDurationFailed)
				}

			case let .loadingThumbnailFinished(video, data):
				guard let index = state.videos.firstIndex(of: video) else {
					return .send(.loadingThumbnailFailed)
				}
				state.videos[index].thumbnail = data
				return .none

			case .loadingThumbnailFailed:
				print("⚠️ ERROR: 썸네일을 가져오는 도중 오류가 발생했습니다.")
				return .none

			case let .loadingDurationFinished(video, duration):
				guard let index = state.videos.firstIndex(of: video) else {
					return .send(.loadingDurationFailed)
				}
				state.videos[index].duration = duration
				return .none

			case .loadingDurationFailed:
				print("⚠️ ERROR: 영상의 플레이타임을 가져오는 도중 오류가 발생했습니다.")
				return .none
			}
		}
	}
}

private extension VideoSectionFeature {
	/// 영상의 길이
	func loadDuration(for video: Video) async throws -> TimeInterval? {
		guard let url = video.source.url else { return nil }
		let asset = AVURLAsset(url: url)
		let duration = try await asset.load(.duration)
		return CMTimeGetSeconds(duration)
	}

	/// 영상의 가장 앞부분을 썸네일로 사용
	func loadThumbnail(for video: Video) async throws -> Data? {
		guard video.source.type != .remote,
					let url = video.source.url else { return nil }

		let asset = AVURLAsset(url: url)
		let imageGenerator = AVAssetImageGenerator(asset: asset)
		let cgImage = try await imageGenerator.image(at: .zero).image
		return cgImage.toData()
	}
}

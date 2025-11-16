//
//  VideoSection.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/17/25.
//

import SwiftUI

import ComposableArchitecture

struct VideoSection: View {
	let title: String
	@Bindable var store: StoreOf<VideoSectionFeature>

	init(title: String, videos: [Video]) {
		self.title = title
		self.store = Store(
			initialState: VideoSectionFeature.State(videos: videos),
			reducer: { VideoSectionFeature() }
		)
	}

	var body: some View {
		Section(title) {
			ForEach($store.videos.sending(\.videoChanged)) { video in
				NavigationLink(value: video.wrappedValue) {
					VideoRow(video: video)
						.task(priority: .background, {
							store.send(.loadDuration(for: video.wrappedValue))
							store.send(.loadThubmnail(for: video.wrappedValue))
						})
				}
			}
		}
	}
}


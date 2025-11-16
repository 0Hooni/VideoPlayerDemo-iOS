//
//  HLSInputTextField.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/16/25.
//

import SwiftUI
import ComposableArchitecture

struct HLSInputTextField: View {

	let store = StoreOf<HLSInputFeature>(
		initialState: HLSInputFeature.State()) {
			HLSInputFeature()
		}

	var body: some View {
		HStack(spacing: 12) {
			TextField(store.placeHolder, text: Binding<String>(
				get: { store.inputText },
				set: { newValue in /* send Action */}
			))
				.textFieldStyle(.roundedBorder)
				.autocapitalization(.none)
				.autocorrectionDisabled()

			Button(action: {
				// viewModel.playHLSVideo()
			}) {
				Image(systemName: "play.circle.fill")
					.font(.title2)
			}
			.disabled(store.inputText.isEmpty)
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 20)
	}
}

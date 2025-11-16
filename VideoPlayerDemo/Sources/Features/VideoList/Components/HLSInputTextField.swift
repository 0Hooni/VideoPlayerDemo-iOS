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
			TextField("HLS 링크를 입력해주세요.", text: Binding<String>(
				get: { store.inputText },
				set: { store.send(.textFieldDidChange(text: $0)) }
			))
				.textFieldStyle(.roundedBorder)
				.autocapitalization(.none)
				.autocorrectionDisabled()

			Button(action: {
				store.send(.playBtnTapped)
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

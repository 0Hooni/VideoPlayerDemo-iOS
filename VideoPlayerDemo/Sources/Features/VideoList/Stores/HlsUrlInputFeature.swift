//
//  HlsUrlInputFeature.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/16/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct HlsUrlInputFeature {

	@ObservableState
	struct State: Equatable {
		var inputText: String = ""
		var isValidURL: Bool = false
		var showInvalidAlert = false
	}

	enum Action {
		case textFieldDidChange(text: String)
		case playBtnTapped
	}

	var body: some Reducer<State, Action> {
		Reduce { state, action in
			switch action {
			case .textFieldDidChange(let text):
				state.inputText = text
				state.isValidURL = isValidURL(text)
				return .none

			case .playBtnTapped:
				if state.isValidURL == false {
					state.showInvalidAlert = true
				} else {
					print("Play Btn Tapped!")
				}
				return .none

			}
		}
	}
}

extension HlsUrlInputFeature {
	private func isValidURL(_ string: String) -> Bool {
		guard let url = URL(string: string) else { return false }
		if url.scheme == "http" || url.scheme == "https" { return true }
		if url.lastPathComponent.hasSuffix(".m3u8") ||
			 url.lastPathComponent.hasSuffix(".m3u") { return true }
		return false
	}
}

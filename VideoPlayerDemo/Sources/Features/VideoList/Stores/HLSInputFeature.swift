//
//  HLSInputFeature.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/16/25.
//

import ComposableArchitecture

@Reducer
struct HLSInputFeature {

	@ObservableState
	struct State: Equatable {
		let placeHolder = "HLS 링크를 입력해주세요."
		var inputText: String = ""
	}

	enum Action {
		case textFieldDidChange(text: String)
		case playBtnTapped
	}
}

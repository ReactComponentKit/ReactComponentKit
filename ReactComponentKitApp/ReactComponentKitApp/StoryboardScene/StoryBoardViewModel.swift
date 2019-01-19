//
//  StoryBoardViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019. 1. 20..
//  Copyright © 2019년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux

struct StoryBoardViewState: State {
    var error: (Error, Action)?
}

class StoryBoardViewModel: RootViewModelType<StoryBoardViewState> {
}

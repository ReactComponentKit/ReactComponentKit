# BKRedux

BKRedux is implementation of Redux store in Swift. 

## How to install

```
pod 'BKRedux'
```

## Counter Example

![](./art/shot.png)

### Define State
 
You should confirm State protocol to define your state.

```swift
struct MyState: State {
    var count: Int = 0
    var color: UIColor = UIColor.white
    var error: (Error, Action)? = nil
}
```


### Deine Actions

```swift
struct IncreaseAction: Action {
    let payload = 1
}

struct DecreaseAction: Action {
    let payload = -1
}

struct RandomColorAction: Action {
    private static let colors = [
        UIColor.blue,
        UIColor.yellow,
        UIColor.red,
        UIColor.magenta,
        UIColor.purple,
        UIColor.brown,
        UIColor.lightGray,
        UIColor.white
    ]
    
    let payload: UIColor = RandomColorAction.colors[Int(arc4random()) % RandomColorAction.colors.count]
}
```

### Define Reducers

#### Reducer for the count state

```swift
import Foundation
import RxSwift

func count(state: State, action: Action) -> Observable<State> {
    guard var mutableState = state as? MyState else { return .just(state) }
        
    switch action {
    case let act as IncreaseAction:
        mutableState.count += act.payload
    case let act as DecreaseAction:
        mutableState.count += act.payload
    default:
        break
    }
    
    return .just(mutableState)
}
```

#### Reducer for the color state

```swift
import RxSwift
import UIKit

func color(state: State, action: Action) -> Observable<State> {
    guard var mutableState = state as? MyState else { return .just(state) }
    
    if let act = action as? RandomColorAction {
        mutableState.color = act.payload
    }
    return .just(mutableState)
}
```

### Make ViewModel if you needed.

BKRedux provides ViewModelType for MVVM. ViewModelType has rx_action and rx_state to make bind more easily.

```swift
import Foundation
import RxSwift
import RxCocoa

struct MyState: State {
    var count: Int = 0
    var color: UIColor = UIColor.white
    
    var stopProgress: Bool = false
    var progress : Float = 0.0
    
    var error: (Error, Action)? = nil
}

class ViewModel: ViewModelType<MyState> {
    
    struct Output {
        let count = BehaviorRelay<String>(value: "0")
        let color = BehaviorRelay<UIColor>(value: UIColor.white)
        let progress = BehaviorRelay<Float>(value: 0.0)
    }
    
    let output = Output()
    override init() {
        super.init()
        
        // STORE
        store.set(
            initialState: MyState(),
            reducers: [
                printCachedValue,
                progress,
                count,
                color,
                cache,
                consoleLog
            ]
        )
    }
    
    override func on(newState: MyState) {
        output.count.accept(String(newState.count))
        output.color.accept(newState.color)
        output.progress.accept(newState.progress)
    }
    
    override func on(error: Error, action: Action, onState: MyState) {
        
    }
    
    deinit {
        print("[## deinit ##]")
    }
}
```

### Make ViewController

```swift
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var startProgressButton: UIButton!
    @IBOutlet weak var stopProgressButton: UIButton!
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        plusButton.rx.tap.map { IncreaseAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)
        minusButton.rx.tap.map { DecreaseAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)
        colorButton.rx.tap.map { RandomColorAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)

        startProgressButton.rx.tap.map { StartProgressAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)
        stopProgressButton.rx.tap.map { StopProgressAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)
        
        viewModel
            .output
            .color
            .asDriver()
            .drive(onNext: { [weak self] (color) in
                if self?.view.backgroundColor != color {
                    self?.view.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .count
            .asDriver()
            .drive(onNext: { [weak self] (countString) in
                self?.countLabel.text = countString
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .progress
            .asDriver()
            .drive(onNext: { [weak self] (progress) in
                self?.progressView.progress = progress
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        viewModel.deinitialize()
    }
        
}
```

### Testing

You can test a redux pipeline like as below:

```swift
import XCTest
import RxSwift
import RxTest

@testable import BKReduxApp

class BKReduxAppTests: XCTestCase {
    
    func testCount() {
        let expectation = self.expectation(description: "testCount")
        let scheduler = TestScheduler(initialClock: 10)
        let disposeBag = DisposeBag()
        let viewModel = ViewModel()
    
        let dispatchActions: TestableObservable<Action> = scheduler.createHotObservable([
            .next(1, IncreaseAction(payload: 3)),
            .next(2, IncreaseAction(payload: 10)),
            .next(3, DecreaseAction()),
            .next(4, DecreaseAction())
        ])
        
        dispatchActions.bind { (action) in
            viewModel.dispatch(action: action)
        }.disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(String.self)
        
        viewModel.output.count.asDriver().drive(onNext: { (value) in
            observer.onNext(value)
            if observer.events.count == dispatchActions.recordedEvents.count + 1 {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        let _ = scheduler.start(disposed: 500) {
            return dispatchActions.asObservable()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(observer.events.count, 5)
            XCTAssertEqual(viewModel.output.count.value, "11")
        }
    }
    
}
```

## MIT License

The MIT License

Copyright © 2018 Sungcheol Kim, http://github.com/ReactComponentKit/BKRedux

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

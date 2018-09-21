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

func countReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
    return { action in
        guard let prevState = state as? Int else { return Observable.just((name, 0)) }
        
        switch action {
        case let increaseAction as IncreaseAction:
            return Observable.just((name, prevState + increaseAction.payload))
        case let decreaseAction as DecreaseAction:
            return Observable.just((name, prevState + decreaseAction.payload))
        default:
            return Observable.just((name, prevState))
        }
    }
}
```

#### Reducer for the color state

```swift
import RxSwift
import UIKit

func colorReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
    return { action in
        guard let prevState = state as? UIColor else { return Observable.just((name: name, result: UIColor.white)) }
        
        if let colorAction = action as? RandomColorAction {
            return Observable.just((name, colorAction.payload))
        }
        return Observable.just((name, prevState))
    }
}```

### Define Middlewares if you needed.

#### Console Log Middleware

```swift
import Foundation
import RxSwift

func consoleLogMiddleware(state: State, action: Action) -> Observable<State> {
    print("[## LOGGING ##] action: \(String(describing: action)) :: state: \(state)")
    return Observable.just(state)
}
```

#### Print Cache Value Middleware

```swift
import Foundation
import RxSwift

func printCacheValue(state: State, action: Action) -> Observable<State> {
    print("[## CACHED ##] value: \(UserDefaults.standard.integer(forKey: "count"))")
    return  Observable.just(state)
}
```

### Define Postwares if you needed.

#### Cache Count Value Postware

```swift
import Foundation
import RxSwift

func cachePostware(state: State, action: Action) -> Observable<State> {
    return Single.create(subscribe: { (single) -> Disposable in
        guard let mystate = state as? MyState else {
            single(.success(state))
            return Disposables.create()
        }
        
        UserDefaults.standard.set(mystate.count, forKey: "count")
        UserDefaults.standard.synchronize()
        single(.success(mystate))
        
        return Disposables.create()
    }).asObservable()
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
    var error: (Error, Action)? = nil
}

class ViewModel: ViewModelType<MyState> {
    
    let rx_count =  BehaviorRelay<String>(value: "0")
    let rx_color = BehaviorRelay<UIColor>(value: UIColor.white)
    
    override init() {
        super.init()

        // STORE
        store.set(
            initailState: MyState(),
            middlewares: [
                printCacheValue,
                consoleLogMiddleware
            ],
            reducers: [
                StateKeyPath(\MyState.count): countReducer,
                StateKeyPath(\MyState.color): colorReducer
            ],
            postwares: [
                cachePostware
            ]
        )
    }
    
    override func on(newState: MyState) {
        rx_count.accept(String(newState.count))
        rx_color.accept(newState.color)
    }
    
    override func on(error: Error, action: Action) {
        
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
    
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton.rx.tap.map { IncreaseAction() }.bind(to: viewModel.rx_action).disposed(by: disposeBag)
        minusButton.rx.tap.map { DecreaseAction() }.bind(to: viewModel.rx_action).disposed(by: disposeBag)
        colorButton.rx.tap.map { RandomColorAction() }.bind(to: viewModel.rx_action).disposed(by: disposeBag)

        viewModel.rx_color
            .asDriver()
            .drive(onNext: { [weak self] (color) in
                if self?.view.backgroundColor != color {
                    self?.view.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.rx_count
            .asDriver()
            .drive(onNext: { [weak self] (countString) in
                self?.countLabel.text = countString
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

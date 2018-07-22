import RxSwift


let disposeBag = DisposeBag()

Observable.from([1, 2, 3, 4, 5])
    .map { (intValue) -> String in
        return String(intValue)
    }
    .reduce("") { (result, value) -> String in
        return result + " " + value
    }
    .subscribe(onNext: { (value) in
        print(value)
    })
    .disposed(by: disposeBag)

//------------------------------------------------
// Redux
//------------------------------------------------

protocol Action {
    
}

struct IncreaseAction: Action {
    
}

struct DecreaseAction: Action {
    
}

struct ReducerResult {
    let name: String
    let value: Any?
}

// lazy 평가를 사용한다.
// 그래야 Action을 변경하며 Reducer를 사용할 수 있다.
typealias Reducer = (Any?) -> (Action) -> Observable<ReducerResult>

struct Person {
    let name: String
}

let a: Reducer = { (state) -> (Action) -> Observable<ReducerResult> in
    return { (action) in
        switch action {
        case _ as IncreaseAction:
            return Observable.just(ReducerResult(name: "a", value: "Hello, World"))
        default:
            return Observable.just(ReducerResult(name: "a", value: state))
        }
    }
    
}

let b: Reducer = { (state) -> (Action) -> Observable<ReducerResult> in
    return { action in
        switch action {
        case _ as IncreaseAction:
            return Observable.just(ReducerResult(name: "b", value: state))
        case _ as DecreaseAction:
            return Single.create(subscribe: { (single) -> Disposable in
                single(.success(ReducerResult(name: "b", value: 100)))
                return Disposables.create()
            }).asObservable()
        default:
            return Observable.just(ReducerResult(name: "b", value: state))
        }
    }
}

func c(state: Any?) -> (Action) -> Observable<ReducerResult> {
    return { action in
        return Observable.just(ReducerResult(name: "c", value: 1.0))
    }
}
//let c: Reducer = { (state, action) -> Observable<ReducerResult> in
//    return Observable.just(ReducerResult(name: "c", value: 1.0))
//}

let person: Reducer = { (state) -> (Action) -> Observable<ReducerResult> in
    return { action in
        Observable.just(ReducerResult(name: "person", value: Person(name: (state as? String) ?? "")))
    }
}

let d: Reducer = { (state) -> (Action) -> Observable<ReducerResult> in
    return { action in
        return Single.create(subscribe: { (single) -> Disposable in
            guard let personList = state as? [Person] else {
                single(.success(ReducerResult(name: "d", value: [])))
                return Disposables.create()
            }
            
            person("HAHA")(action)
                .subscribe(onNext: { (resultTypeList) in
                    if let haha = resultTypeList.value as? Person {
                        var mutablePersonList = personList
                        mutablePersonList.append(haha)
                        single(.success(ReducerResult(name: "d", value: mutablePersonList)))
                    } else {
                        single(.success(ReducerResult(name: "d", value: personList)))
                    }
                }).dispose()
            
            
            return Disposables.create()
        }).asObservable()
    }
}

var state: [String:Any] = [:]

state["a"] = "Hello"
state["d"] = []

print(state)

//var newState = state
let action = DecreaseAction()

/*
 let reducers = [a(state["a"])(action), b(state["b"])(action), c(state: state["c"])(action), d(state["d"])(action)]
 Observable.combineLatest(reducers)
 .subscribe(onNext: { (resultTypeList) in
 resultTypeList.forEach { resultType in
 newState[resultType.name] = resultType.value
 }
 print(newState)
 })
 .disposed(by: disposeBag)
 
 */

// 액션 파라미터화 하기
func newState(state: [String:Any], action: Action) -> Observable<[String:Any]> {
    
    return Single.create(subscribe: { (single) -> Disposable in
        
        var newState = state
        
        // 나중에는 이것이 Store 클래스 멤버로 구현될 예정
        let reducers = [a(state["a"]), b(state["b"]), c(state: state["c"]), d(state["d"])]
        
        Observable.combineLatest(reducers.map { $0(action) })
            .subscribe(onNext: { (resultTypeList) in
                resultTypeList.forEach { resultType in
                    newState[resultType.name] = resultType.value
                }
                single(.success(newState))
            })
        
        return Disposables.create()
    }).asObservable()
    
}

newState(state: state, action: IncreaseAction())
    .subscribe(onNext: { (state) in
        print(state)
    })
    .dispose()

// API를 사용한다고 하면
// API응답을 받아온다
// 응답의 각 필드를 reducer 목록으로 변환환다. ResponseObject -> CombineLastest([reducer...])

class Store {
    
}

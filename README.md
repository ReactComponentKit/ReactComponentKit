<div align="center">
	<img src="https://raw.githubusercontent.com/ReactComponentKit/ReactComponentKit/master/art/logo.png">
</div>

<div align="center">
	<img src="https://img.shields.io/badge/iOS-%3E%3D%209.0-green.svg" />
	<img src="https://img.shields.io/badge/Swift-%3E%3D%204.1-orange.svg" />
	<img src="https://img.shields.io/cocoapods/v/ReactComponentKit.svg" />
	<img src="https://img.shields.io/github/license/ReactComponentKit/ReactComponentKit.svg" />
</div>


# ReactComponentKit

ReactComponentKit is a library for building UIViewControllers. You can make UIViewControllers based on Components. Also, It uses MVVM and Redux architectures for unidirectional data flow.

<div align="center"><img src="https://raw.githubusercontent.com/ReactComponentKit/ReactComponentKit/master/art/ReactComponentKit.png"></div>

## Data Flow

 * (1) : Components dispatch actions
 * (2) : ViewModel passes the actions to the store. You can use beforeDispatch(action:) method to do some work before dispatching actions.
 * (3) : Store passed current state to the Redux pipeline. Middlewares, Reducers and Postwares make a new state.
 * (4) : New State comes out from the Redux pipeline. It is passed to the store.
 * (5) : Store passes the new state to the ViewModel.
 * (6) : ViewModel passes or propagates the state to the Components.

## Components

ReactComponentKit provides four components basically. 

 * UIViewComponent
 	* It is a basic component for making a scene. It is just a UIView that has some convenient methods for dispatching actions and receiving states.
 * UICollectionViewComponent
 	* It is a component for making a scene that uses UICollectionView.
 * UITableViewComponent
 	* It is a component for making a scene that uses UITableView.
 * UIViewControllerComponent
 	* It is a component for spliting a massive view controller. 

## Examples

 * [Counter](https://github.com/ReactComponentKit/Counter)
	* Counter is a very simple and basic redux example.
 * [EmojiCollection](https://github.com/ReactComponentKit/EmojiCollection)
 	* EmojiCollection is a example for using UICollectionView and Diff algorithms.
 * [UserList](https://github.com/ReactComponentKit/UserList)
	* UserList is focus on requesting api asynchronously.

## How to install

```
pod 'ReactComponentKit'
```

## 시작하기

 * [시작하기 문서 보기](https://github.com/ReactComponentKit/ReactComponentKit/wiki/%EC%8B%9C%EC%9E%91%ED%95%98%EA%B8%B0)

## Getting Started

 * writing...


## MIT License

The MIT License

Copyright © 2018 Sungcheol Kim, https://github.com/ReactComponentKit/ReactComponentKit

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

# EventBus

EventBus is tiny, simple typed event bus to communicate between components. It is built on NSNotificationCenter. 

## How to install

```
pod 'BKEventBus'
```

## Why Use EventBus?

If you want to remove dependencies between components or layers, you'd better to use event bus. Removing dependency is always important thing when you make software. EventBus helps you it more easily. It is typed EventBus. You can define Event type and arguments and you can use it somewhere.

## How to use EventBus

### Define EventType

You can define event type using EventType protocol. It is just marking as event type. You can use every types like as class, struct or enum. I prefer to use enum :) You can define events like as below:


```swift
enum Actions: EventType {
	case push(item: String)
	case pop
	case loading(item: String)
	case delete(item: String)
}
```

### Make Event Poster

```swift
...
let eventBus: EventBus<Actions> = EventBus()
...
```

### Post Events

```swift
eventBus.post(event: .push(item: "Something"))
eventBus.post(event: .pop)
eventBus.post(event: .loding(item: "1234"))
eventBus.pose(event: .delete(item: "1234"))
```


### Subscribe Events

```swift
// Somewhere
{
...

	let eventBus: EventBus<Actions> = EventBus()
	eventBus.on { [weak self] (event: Actions) in
		switch event {
		case let .push(item):
			...
		case pop:
			...
		case loding(item):
			...
		case delete(item):
			...
		}
	}
	
...
}
```

## Life cycle

You can stop or resume event bus with life cycle methods. 

### Resume EventBus

```swift
eventBus.resume()
```

### Stop EventBus

```swift
eventBus.stop()
```

Or You can stop event bus by deleting it.

```swift
// Define Event Bus
var eventBus: EventBus<Actions>? = EventBus()
...
Use it
...

// Delete it
eventBus = nil
```

## Simple Example

### Commumicate between CollectionViewCell and ViewController.

#### Define Events at Cell

```swift
class ItemCollectionViewCell: UICollectionViewCell {
    
    // Define Events
    enum Event: EventType {
        case clickedDeleteButton(indexPath: IndexPath)
        case clickedDetailButton(indexPath: IndexPath)
    }
    
    static var className: String {
        return String(describing: self)
    }

    @IBOutlet weak var dateLabel: UILabel!

    private var indexPath: IndexPath? = nil
    private var eventBus: EventBus<ItemCollectionViewCell.Event>? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventBus = nil
    }
    
    func configure(item: String, indexPath: IndexPath) {
        self.dateLabel.text = item
        self.indexPath = indexPath
        eventBus = EventBus()
    }
    
    // Post Events
    @IBAction func clickedDetailButton(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        eventBus?.post(event: .clickedDetailButton(indexPath: indexPath))
    }
    
    @IBAction func clickedDeleteButton(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        eventBus?.post(event: .clickedDeleteButton(indexPath: indexPath))
    }
}
```


#### Subscribe events on ViewController

```swift
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var items: [String] = []
    private let eventBus = EventBus<ItemCollectionViewCell.Event>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Date List"
        collectionView.register(UINib(nibName: ItemCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ItemCollectionViewCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Subscribe events
        eventBus.on { [weak self] (event: ItemCollectionViewCell.Event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .clickedDeleteButton(indexPath):
                strongSelf.items.remove(at: indexPath.row)
                strongSelf.collectionView.reloadData()
            case let .clickedDetailButton(indexPath):
                let item = strongSelf.items[indexPath.row]
                let vc = DetailViewController.viewController(item: item)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func clickedAddButtonItem(_ sender: Any) {
        let date = Date()
        items.append(date.description)
        collectionView.reloadData()
    }
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.className, for: indexPath)
        if let itemCell = cell as? ItemCollectionViewCell {
            itemCell.configure(item: items[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
}
```

## MIT License

The MIT License

Copyright © 2018 Sungcheol Kim, http://github.com/ReactComponentKit/BKEventBus

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
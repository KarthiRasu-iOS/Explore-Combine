# Explore Combine

## Apple's guide : Customize handling of asynchronous events by combining event-processing operators. The Combine framework provides a declarative Swift API for processing values over time 🤔

> [!Note]
> What is Declarative?
> Definition : A paradigm focuses on what the program should accomplish, without specifying how to achieve it. The programmer defines the desired result, and the system takes care of the underlying steps to achieve it.
> Realtime Example : Ordering a meal at a restaurant by saying, "I want a pizza with extra cheese" (you state the result you want). As we don't know the underlying process of making pizza in that restaurant it's called declarative

## Swift UI is an declarative Framework

``` swift
Text("Hello, World!")
``` 
Above we declared the Text to render in UI, and SwiftUI handles the rendering.

> [!Note]
> What is Imperative?
> Definition : A paradigm focuses on how the program should operate, specifying a sequence of commands to execute tasks.
> Realtime Example : Making the pizza yourself, step by step: preparing the dough, adding toppings, baking it, and serving it.

## UIKit is an imperative Framwork

``` swift
let label = UILabel()
label.text = "Hello, World!"
view.addSubview(label)
```
Above you manage the creation and adding to the views manually.


## Example Without using Combine

In below example based on the switch State the Save Changes Button will be enable / disable, here I'm using an function to update the button by calling the validateToSaveChanges() function. 

```swift
import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var shareProfileSwitch : UISwitch!
    @IBOutlet weak var saveChangesBtn : UIButton!
    
    //MARK: - Switch Action Button
    
    @IBAction func didSwitchChange(_ sender: UISwitch) {
        validateToSaveChanges()
    }
    
    func validateToSaveChanges() {
        saveChangesBtn.isEnabled = shareProfileSwitch.isOn
    }
}

``` 

## Example with Combine

Below example an property wrapper @Published is used to listening the changes of the switch.

Inside the viewDidLoad() we are subscribing to the isShareEnabled with $ sign 

    $isShareEnabled ( $ allows you to access the wrapped Publisher value)

    .receive function -> receving the new value on the main thread
    
    .assign function -> assign the received value to the keyPath (isEnabled) of saveChangesBtn

AnyCancellable : Memory management in Combine 

Once a subscription is no longer needed, it should release all references correctly, below we assigning the subscriber to switchSubscriber
    
    The lifecycle of switchSubscriber is linked to ViewController, Whenever the view controller is released, the property is released as well and the cancel() method of the subscription is called


```swift
import UIKit
import Combine

class ViewController: UIViewController {
    
    
    //MARK: - Property Wrapper
    
    @Published var isShareEnabled : Bool = false
    private var switchSubscriber: AnyCancellable?
    
    //MARK: - Outlets
    
    @IBOutlet weak var shareProfileSwitch : UISwitch!
    @IBOutlet weak var saveChangesBtn : UIButton!


    override func viewDidLoad() {
        
        switchSubscriber = $isShareEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: saveChangesBtn)
    }
    
    //MARK: - Switch Action Button
    
    @IBAction func didSwitchChange(_ sender: UISwitch) {
        isShareEnabled = sender.isOn
    }
}

```


![Demo](https://raw.githubusercontent.com/KarthiRasu-iOS/Explore-Combine/master/demo/combine_demo_a.gif)


## Publisher protocol

A publisher is nothing more than an object that emit a stream of values over time.
These values can be consumed by one or more subscribers, which can then update the state of user interface or perfrom any other actions.

> [!Note]
> Built In Publishers :- 
> Just
> Future
> PassthroughSubject
> CurrentValueSubject


## Passthrough Subject 

- **Purpose**: A simple subject for broadcasting values to subscribers.
- **Behavior**:
  - Does not store any value.
  - Subscribers only receive values that are emitted *after* they subscribe.
  - Useful for sending events or signals that don’t need to maintain state or replay previous values.
- **Example Use Case**: Triggering an action, such as notifying subscribers when a button is tapped.

## CurrentValueSubject

- **Purpose**: A subject that keeps a current value and emits it to new subscribers.
- **Behavior**:
    - Stores the most recent value.
    - New subscribers receive the latest value immediately upon subscription, followed by any subsequent values.
    - Useful for state management where you need to keep track of the latest value.
    
- **Example Use Case**: Sharing the current state of an application, such as the current selected tab or theme.


## Passthorugh Subject vs CurrentValueSubject


| Feature  | PassthroughSubject | CurrentValueSubject
| ------------- | ------------- | ------------- |
| Initial Value | None  | Requires an initial value.
| State Storage  | Does not store values.  |  Stores the latest value.
| Subscriber Behavior  | Subscribers only get new values.  |  Subscribers get the current value and new values.
| Use Case | Event broadcasting (e.g., button taps). |  State sharing (e.g., current app state).

# Explore Combine

## Apple's guide : Customize handling of asynchronous events by combining event-processing operators. The Combine framework provides a declarative Swift API for processing values over time 🤔

> [!Note]
> Declarative ?

> Definition : A paradigm focuses on what the program should accomplish, without specifying how to achieve it. The programmer defines the desired result, and the system takes care of the underlying steps to achieve it.

> Realtime Example : Ordering a meal at a restaurant by saying, "I want a pizza with extra cheese" (you state the result you want). As we don't know the underlying process of making pizza in that restaurant it's called declarative

## Swift UI is an declarative Framework

``` swift
Text("Hello, World!")
``` 
Above we declared the Text to render in UI, and SwiftUI handles the rendering.

> [!Note]
> Imperative ?

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

<video src="https://github.com/KarthiRasu-iOS/Explore-Combine/blob/master/demo/Combine-Demo-A.mp4"/>



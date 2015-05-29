# KFPopupSelector
__KFPopupSelector__ is a Cocoa Touch control which presents a simple popup menu containing several string options. Its features are:

* Written in Swift, using modern Swift language features.

* Is entirely encapsulated in a `UIControl` subclass, and designed to be used in Storyboards. Emits a `valueChanged` event when the value changes.

* Handling of button label is configurable; can be fixed or changed to selected value, and can optionally be decorated with a downward triangle.

There is more information on the design and implementation of this control [here](http://tech.null.org/item/201505291610_popover_menu_ctrl_io).

## Example

A simple example of using KFPopupSelector:
```swift
class MyViewController : UIViewController {

    // KFPopupSelector is added in the Storyboard and linked here.
    @IBOutlet var popup: KFPopupSelector!

    override func viewDidLoad() {
        super.viewDidLoad()
        // configure the KFPopupSelector's options

        popup.options = [ .Text(text:"Red"), .Text(text:"Green"), .Text(text:"Blue") ]
        popup.labelDecoration = .DownwardTriangle
        popup.unselectedLabelText = "Please pick a colour"
    }

    // This method is wired to the KFPopupSelector's valueChanged message in the Storyboard
    @IBAction func popupChanged(sender: AnyObject!) {
        println("You selected option number \(popup.selectedIndex!)")
    }
}
```

## Using KFPopupSelector in your own projects

KFPopupSelector is entirely encapsulated in one source file, `KFPopupSelector.swift`; simply add this to your project and use.

KFPopupSelector is licenced under the MIT Licence.

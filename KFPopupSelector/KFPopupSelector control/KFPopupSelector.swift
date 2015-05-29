//
//  KFPopupSelector.swift
//  KFPopupSelector
//
//  Created by acb on 27/05/2015.
//  Copyright (c) 2015 Kineticfactory. All rights reserved.
//

import UIKit

class KFPopupSelector: UIControl, UIPopoverPresentationControllerDelegate {
    
    enum Option {
        case Text(text:String)
        
        func intrinsicWidthWithFont(font: UIFont) -> CGFloat {
            switch(self) {
            case Text(let t): return NSString(string:t).boundingRectWithSize(CGSize(width:1000, height:1000), options:.allZeros, attributes:[NSFontAttributeName: font], context:nil).width
            }
        }
    }
    
    /** The options the user has to choose from */
    var options: [Option] = [] 
    
    /** The currently selected value */
    var selectedIndex: Int? = nil {
        didSet {
            updateLabel()
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    /** The text to display on the button if no option is selected */
    var unselectedLabelText:String = "--" {
        didSet {
            updateLabel()
        }
    }
    
    /** if true, replace the button's text with the currently selected item */
    var displaySelectedValueInLabel: Bool = true
    
    /** How the button title is displayed */
    enum LabelDecoration {
    case None
    case DownwardTriangle        
        func apply(str:String) ->String {
            switch(self) {
            case None: return str
            case DownwardTriangle: return str + " ▾"
            }
        }
    }
    var labelDecoration: LabelDecoration = .None {
        didSet {
            updateLabel()
        }
    }
    
    func updateLabel() {
        if selectedIndex != nil && displaySelectedValueInLabel {
            switch (options[selectedIndex!]) {
            case .Text(let text): buttonText = text
            }
        } else {
            buttonText = unselectedLabelText
        }
    }
    
    // -------- The TableViewController used internally in the popover
    
    class PopupViewController: UITableViewController {
        let minWidth: CGFloat = 40.0
        var optionsWidth: CGFloat = 40.0
        
        private let tableViewFont = UIFont.systemFontOfSize(15.0)

        var options: [Option] = [] {
            didSet {
                optionsWidth = options.map { $0.intrinsicWidthWithFont(self.tableViewFont) }.reduce(minWidth) { max($0, $1) }
            }
        }
        
        var itemSelected: ((Int)->())? = nil
        
        let KFPopupSelectorCellReuseId = "KFPopupSelectorCell"
                
        override var preferredContentSize: CGSize { 
            get {
                tableView.layoutIfNeeded()
                return CGSize(width:optionsWidth+32, height:tableView.contentSize.height)
            }
            set {
                println("Cannot set preferredContentSize of this view controller!")
            }
        }
        
        override func loadView() {
            super.loadView()
            tableView.rowHeight = 36.0
            tableView.separatorStyle = .None
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            tableView.scrollEnabled = (tableView.contentSize.height > tableView.frame.size.height)
        }
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return options.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = (tableView.dequeueReusableCellWithIdentifier(KFPopupSelectorCellReuseId) ?? UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: KFPopupSelectorCellReuseId)) as! UITableViewCell
            switch options[indexPath.row]  {
            case .Text(let text): 
                cell.textLabel?.text = text
                cell.textLabel?.font = tableViewFont
            }
            return cell
        }
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            itemSelected?(indexPath.row)
        }
    }
    
    // --------------------------------
    
    var currentlyPresentedPopup: PopupViewController? = nil
    
    private let button = UIButton.buttonWithType(.System) as! UIButton
    
    private var buttonText: String? {
        get {
            return button.titleForState(.Normal)
        }
        set {
            button.setTitle(newValue.map { self.labelDecoration.apply($0) }, forState: .Normal)
            invalidateIntrinsicContentSize()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return button.intrinsicContentSize()
    }

    override func awakeFromNib() {
        button.setTitle(labelDecoration.apply(unselectedLabelText), forState: .Normal)
        self.addSubview(button)
        button.frame = self.bounds
        button.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        button.addTarget(self, action: Selector("buttonPressed:"), forControlEvents:.TouchDown)
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("dragged:")))
    }
    
    private var viewController: UIViewController? {
        for var next:UIView? = self.superview; next != nil; next = next?.superview {
            let responder = next?.nextResponder()
            if let vc = responder as? UIViewController {
                return vc
            }
        }
        return nil
    }
    
    func dragged(sender: UIPanGestureRecognizer!) {
        if let tableView = currentlyPresentedPopup?.tableView {
            switch(sender.state) {
            case .Changed:
                if let popupContainer = tableView.superview {
                    let pos = sender.locationInView(tableView)
                    if let ip = tableView.indexPathForRowAtPoint(pos) {
                        tableView.selectRowAtIndexPath(ip, animated: false, scrollPosition: UITableViewScrollPosition.None)
                    }
                }
            case .Ended:
                if let ip = tableView.indexPathForSelectedRow() {
                    currentlyPresentedPopup!.dismissViewControllerAnimated(true){ 
                        self.currentlyPresentedPopup = nil 
                        self.selectedIndex = ip.row
                    }
                }
            default: break
            }
        }
    }
    
    func buttonPressed(sender: AnyObject?) {
        if options.count > 0 {
            let pvc = PopupViewController(style: UITableViewStyle.Plain)
            pvc.options = options
            pvc.itemSelected = { (index:Int) -> () in 
                pvc.dismissViewControllerAnimated(true) { 
                    self.currentlyPresentedPopup = nil 
                    self.selectedIndex = index
                }
            }
            pvc.modalPresentationStyle = .Popover
            currentlyPresentedPopup = pvc
            
            let pc = pvc.popoverPresentationController
            pc?.sourceView = self
            pc?.sourceRect = button.frame
            pc?.permittedArrowDirections = .Any
            pc?.delegate = self
            
            viewController!.presentViewController(pvc, animated: true) {}
        }
    }
    
    
    // MARK: UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        currentlyPresentedPopup = nil
    }
}

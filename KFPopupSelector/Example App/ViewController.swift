//
//  ViewController.swift
//  KFPopupSelector
//
//  Created by acb on 27/05/2015.
//  Copyright (c) 2015 Kineticfactory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var popup1: KFPopupSelector!
    @IBOutlet var popup2: KFPopupSelector!
    @IBOutlet var popup3: KFPopupSelector!
    @IBOutlet var textField1: UITextField!
    
    let addFieldOptions = [
        "Phone", "Mobile", "Email", "Twitter"
    ]
    
    // Possibly incomplete, but it's just an example...
    let countries = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Anguilla", "Antigua & Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia & Herzegovina", "Botswana", "Brazil", "British Virgin Islands", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Cape Verde", "Cayman Islands", "Chad", "Chile", "China", "Colombia", "Congo", "Cook Islands", "Costa Rica", "Cote D Ivoire", "Croatia", "Cruise Ship", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Estonia", "Ethiopia", "Falkland Islands", "Faroe Islands", "Fiji", "Finland", "France", "French Polynesia", "French West Indies", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea Bissau", "Guyana", "Haiti", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya", "Kuwait", "Kyrgyz Republic", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Mauritania", "Mauritius", "Mexico", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Namibia", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russia", "Rwanda", "Saint Pierre & Miquelon", "Samoa", "San Marino", "Satellite", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "South Africa", "South Korea", "Spain", "Sri Lanka", "St Kitts & Nevis", "St Lucia", "St Vincent", "St. Lucia", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor L'Este", "Togo", "Tonga", "Trinidad & Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks & Caicos", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "Uruguay", "Uzbekistan", "Venezuela", "Vietnam", "Virgin Islands (US)", "Yemen", "Zambia", "Zimbabwe"]
    
    let actions = [ "Email", "Upload", "Translate", "Convert to GIF" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        popup1.options = addFieldOptions.map { KFPopupSelector.Option.Text(text:$0) }
        popup1.selectedIndex = 0
        popup1.labelDecoration = .DownwardTriangle
        
        popup2.options = countries.map { KFPopupSelector.Option.Text(text:$0) }
        popup2.unselectedLabelText = "(Select one)"
        popup2.displaySelectedValueInLabel = true
        
        popup3.options = actions.map { KFPopupSelector.Option.Text(text:$0) }
        popup3.unselectedLabelText = "Actions"
        popup3.displaySelectedValueInLabel = false
    }

    @IBAction func addButtonTapped(sender: AnyObject?) {
        let msg = "Adding \(textField1.text!) as \(addFieldOptions[popup1.selectedIndex!])"
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default){(action)->() in })
        presentViewController(alert, animated: true) {}
    }
    
    @IBAction func countryChanged(sender: AnyObject?) {
        let alert = UIAlertController(title: "", message: "Country is \(countries[popup2.selectedIndex!])", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default){(action)->() in })
        presentViewController(alert, animated: true) {}
    }

    @IBAction func actionSelected(sender: AnyObject?) {
        let alert = UIAlertController(title: "", message: "\(actions[popup3.selectedIndex!])", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default){(action)->() in })
        presentViewController(alert, animated: true) {}
    }
    
}


# Wizardry
![wizard](Images/wizard.png)

A reusable way to allow users to perform a multipart task in your iOS app, written in Swift.

![sign up wizard demo](Images/signup_wizard.png)

The demo implements a wizard that allows users to sign up to use an app.

Classes in the framework make no assumption about, nor impose restrictions upon, your wizard's visual design.

Important functionality in the wizard framework has thorough unit test coverage.

## How to use it

#### Wizard Step View Controllers
Create a `UIViewController` subclass for every step/screen in your wizard. 

Example: [UsernameStepViewController](/Demo/WizardryDemo/SignUpWizard/UsernameStepViewController.swift)

#### Wizard Steps
For every step in your wizard, create a type that adopts the `WizardStep` protocol. An instance of this type owns a wizard step view controller and collects & processes user input for that view controller. 

Example: [UsernameWizardStep](/Demo/WizardryDemo/SignUpWizard/UsernameWizardStep.swift)

> Note: It is possible to have wizard step view controllers adopt the `WizardStep` protocol, if preferred.

#### Data Source
Adopt the `WizardDataSource` protocol to determine the order in which a user will view your wizard steps. 

Example: [SignUpWizardDataSource](/Demo/WizardryDemo/SignUpWizard/SignUpWizardDataSource.swift)

#### Wizard View Controller
Subclass `WizardViewController` and implement your custom UI design to navigate between wizard step views. You will need to override three methods:
```swift
func navigateToInitial(wizardStep: WizardStep)    
func navigateToNext(wizardStep: WizardStep, placement: WizardStepPlacement)
func navigateToPrevious(wizardStep: WizardStep, placement: WizardStepPlacement)
```
Example: [SignUpWizardViewController](/Demo/WizardryDemo/SignUpWizard/SignUpWizardViewController.swift)

#### Show The Wizard
Create your wizard view controller and configure it with your custom data source before presenting it to the user.
```swift
@IBAction func handleShowSignUpWizardButton(sender: UIButton) {
    let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
    let signUpWizardVC = storyboard.instantiateInitialViewController() as! SignUpWizardViewController
    let model = SignUpWizardModel()
    let dataSource = SignUpWizardDataSource(model: model)
    
    signUpWizardVC.configureWith(dataSource, completionHandler: { [weak self] (canceled: Bool) in
        print("Completed sign up wizard. canceled = \(canceled)")
        self?.dismissViewControllerAnimated(true, completion: nil)
        })

    presentViewController(signUpWizardVC, animated: true, completion: nil)
}
```
Example: [ViewController](/Demo/WizardryDemo/ViewController.swift)

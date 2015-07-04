# flip-label
<img src="/Flip Label/ScreenCapture.gif" align="right">
A label that lets you change its text with a cool flip animation.

GWFlipLabel is a subclass of UIView that is very similar to a UILabel. GWFlipLabel implements a read-only text view. You can draw one line of static text that is styled using the other properties of this class. All of the styling properties are applied to the entire string in the text property.
 
New label objects are configured to disregard user events by default. If you want to attatch a gesture to a GWFlipLabel, you must explicitly change the value of the userInteractionEnabled property to YES after initializing the object.
 
GWFlipLabel adds functionality to animate new text onto the screen. The old text will fade out and the new text will flip up onto the screen character by character.

The Xcode project in the repository has a working example of the flip label in use. This demo is a screen recording from the project.

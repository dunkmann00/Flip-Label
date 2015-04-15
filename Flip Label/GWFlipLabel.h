//
//  GWFlipLabel.h
//  Flip Animation Label
//
//  Created by George Waters on 2/20/15.
//  Copyright (c) 2015 George Waters. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @typedef GWVerticalAlignment
 
 @constant GWVerticalAlignmentTop Aligns text to the top of the label.
 @constant GWVerticalAlignmentCenter Aligns text to the center of the label.
 @constant GWVerticalAlignmentBottom Aligns text to the botom of the label.
 
 @abstract Options for aligning text vertically.
 */
typedef NS_ENUM(NSInteger, GWVerticalAlignment) {
    /**Aligns text to the top of the label*/
    GWVerticalAlignmentTop,
    /**Aligns text to the center of the label*/
    GWVerticalAlignmentCenter,
    /**Aligns text to the botom of the label*/
    GWVerticalAlignmentBottom
};

/**
 A subclass of UIView that is very similar to a UILabel. GWFlipLabel implements a read-only text view. You can draw one line of static text that is styled using the other properties of this class. All of the styling properties are applied to the entire string in the text property.
 
 New label objects are configured to disregard user events by default. If you want to attatch a gesture to a GWFlipLabel, you must explicitly change the value of the userInteractionEnabled property to YES after initializing the object.
 
 GWFlipLabel adds functionality to animate new text onto the screen. The old text will fade out and the new text will flip up onto the screen character by character.
 */
@interface GWFlipLabel : UIView

/**
 The text displayed by the label.
 
 This string is nil by default.
 */
@property (nonatomic, copy) NSString *text;

/**
 The font of the text.
 
 The default value for this property is the system font at a size of 17 points (using the systemFontOfSize: class method of UIFont). The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property (nonatomic, strong) UIFont *font;

/**
 The color of the text.
 
 The default value for this property is a black color (set through the blackColor class method of UIColor). The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 The technique to use for aligning the text horizontally.
 
 The default value of this property is NSTextAlignmentLeft.
 */
@property (nonatomic) NSTextAlignment textAlignment;

/**
 The technique to use for aligning the text vertically.
 
 The default value of this property is GWVerticalAlignmentCenter.
 */
@property (nonatomic) GWVerticalAlignment verticalAlignment;

/**
 Dynamically sizes text to fit in the Flip Animation Label.
 
 This property is similar to the 'adjustsFontSizeToFitWidth' property on a UILabel except you do not need to set the font size at all when this is set to YES. This will size text so that it perfectly fits inside the label, making text bigger or smaller as is needed. The default value is NO.
 */
@property (nonatomic) BOOL dynamicFontSize;

/**
 The shadow color of the text.
 
 The default value for this property is nil, which indicates that no shadow is drawn. In addition to this property, you may also want to change the default shadow offset by modifying the shadowOffset property. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property(nonatomic, strong) UIColor *shadowColor;

/**
 The shadow offset (measured in points) for the text.
 
 The shadow color must be non-nil for this property to have any effect. The default offset size is (0, -1), which indicates a shadow one point above the text. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property(nonatomic) CGSize shadowOffset;

/**
 A Boolean value that determines whether user events are ignored and removed from the event queue.
 
 This property is inherited from the UIView parent class. This class changes the default value of this property to NO.
 */
@property(nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

/**
 @param bounds The bounding rectangle of the receiver.
 
 @return The computed drawing rectangle for the label’s text.
 
 Returns the drawing rectangle for the label’s text.
 
 This method returns the exact location and size of the rectangle in the coordinate space of the label that contains the label's text. Since a GWFlipLabel only has one line, the size is computed based on that.
 */
- (CGRect)textRectForBounds:(CGRect)bounds;

/**
 @param duration The total duration of the animation, measured in seconds. If you specify a value less than 0.75, the animation will complete in 0.75 seconds.
 @param text The new text for the textLabel.
 @param completionHandler A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. This parameter may be NULL.
 
 Animates new text onto the textLabel by fading out the old text and flipping the new text onto it.
 */
- (void)setTextWithFlipAnimationDuration:(NSTimeInterval)duration text:(NSString *)text completion:(void(^)(BOOL finished))completionHandler;

@end

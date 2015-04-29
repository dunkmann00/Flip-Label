//
//  GWFlipLabel.m
//  Flip Animation Label
//
//  Created by George Waters on 2/20/15.
//  Copyright (c) 2015 George Waters. All rights reserved.
//

#import "GWFlipLabel.h"

@interface GWFlipLabel ()

@property (nonatomic) BOOL dynamicallySizing;

@property (nonatomic) BOOL isAnimating;

@property (nonatomic) BOOL updateFontSize;

@property (nonatomic) BOOL hasRendered;

@end

@implementation GWFlipLabel

@dynamic userInteractionEnabled;

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(self.dynamicFontSize)
        [self setNeedsFontSize];
    
}

-(void)setBounds:(CGRect)bounds
{
    [UIView performWithoutAnimation:^{
        [super setBounds:bounds];
        if(self.dynamicFontSize)
            [self setNeedsFontSize];
    }];
}

-(void)setText:(NSString *)text
{
    _text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //When there are spaces after the text the flip animation does not work as it should. This is because the size of the text rect accounts for the spaces however the text is drawn as if there was no spaces after it. So when the label is center aligned or right aligned it does not appear where it would based on just the size rect and alignment. The simplest way to avoid this is to trim the input string to have no whitespaces on the end (spaces in the beginning don't matter but this will remove them as well)
    [self setNeedsDisplay];
    if(self.dynamicFontSize)
        [self setNeedsFontSize];
}

-(void)setFont:(UIFont *)font
{
    if(!font)
    {
        NSException *fontException = [NSException exceptionWithName:@"Set Font to nil" reason:@"The font of a GWFlipLabel must be non-nil" userInfo:@{@"Font" : [NSNull null]}];
        [fontException raise];
    }
    _font = font;
    if(!self.dynamicallySizing)
    {
        [self setNeedsDisplay];
        if(self.dynamicFontSize)
            [self setNeedsFontSize];
    }
}

-(void)setTextColor:(UIColor *)textColor
{
    if(!textColor)
    {
        NSException *textColorException = [NSException exceptionWithName:@"Set Text Color to nil" reason:@"The text color of a GWFlipLabel must be non-nil" userInfo:@{@"TextColor" : [NSNull null]}];
        [textColorException raise];
    }
    _textColor = textColor;
    [self setNeedsDisplay];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setNeedsDisplay];
}

-(void)setVerticalAlignment:(GWVerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

-(void)setDynamicFontSize:(BOOL)dynamicFontSize
{
    _dynamicFontSize = dynamicFontSize;
    if(_dynamicFontSize)
    {
        [self setNeedsDisplay];
        [self setNeedsFontSize];
    }
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    [self setNeedsDisplay];
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    [self setNeedsDisplay];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self initialConfigure];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialConfigure];
}

-(void)initialConfigure
{
    _shadowOffset = CGSizeMake(0, -1);
    _textAlignment = NSTextAlignmentLeft;
    _verticalAlignment = GWVerticalAlignmentCenter;
    _font = [UIFont systemFontOfSize:17.0];
    _textColor = [UIColor blackColor];
    self.userInteractionEnabled = NO;
    self.contentMode = UIViewContentModeRedraw;
    
}

-(void)setNeedsFontSize
{
    self.updateFontSize = YES;
}

- (void)drawRect:(CGRect)rect {
    self.hasRendered = YES;
    
    if(!self.isAnimating)
    {
        CGRect textRect = [self textRectForBounds:self.bounds];
        if(!CGSizeEqualToSize(textRect.size, CGSizeZero))
        {
            CGContextRef currentContext = UIGraphicsGetCurrentContext();
            CGContextSaveGState(currentContext);
            CGContextTranslateCTM(currentContext, 0.0, textRect.origin.y);
            [self drawText];
            CGContextRestoreGState(currentContext);
        }
    }
}

-(void)drawText
{
    //A graphics context must be already setup when this method is called
    
    CGSize textSize = [self sizeThatFits:CGSizeZero]; //Only needed for the height.
    
    [self.text drawInRect:CGRectMake(0.0, 0.0, self.bounds.size.width, textSize.height) withAttributes:[self labelAttributesWithFont:self.font]];
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGSize textSize = [self sizeThatFits:CGSizeZero];
    CGFloat xOrigin = positionOfRect(textSize.width, bounds.size.width, self.textAlignment);
    CGFloat yOrigin = positionOfRect(textSize.height, bounds.size.height, self.verticalAlignment);
    
    if(xOrigin < 0.0)
        xOrigin = 0.0;
    
    if(yOrigin < 0.0)
        yOrigin = 0.0;
    
    if(textSize.width > bounds.size.width)
        textSize.width = bounds.size.width;
    
    if(textSize.height > bounds.size.height)
        textSize.height = bounds.size.height;
    
    return CGRectMake(xOrigin, yOrigin, textSize.width, textSize.height);
}

-(CGSize)sizeThatFits:(CGSize)size
{
    if(self.updateFontSize)
        [self dynamicallySizeFont];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize textSize = [self.text sizeWithAttributes:[self labelAttributesWithFont:self.font]];
    textSize.width = ceilf(textSize.width * scale) / scale;
    textSize.height = ceilf(textSize.height * scale) / scale;
    
    return textSize;
}

-(void)dynamicallySizeFont
{
    self.dynamicallySizing = YES;
    if([self.text length] > 0)
    {
        CGSize sizeWithFont;
        CGFloat fontSize = 10.0;
        UIFont *fontToSize;
        
        fontToSize = [self.font fontWithSize:fontSize];
        sizeWithFont = [self.text sizeWithAttributes:[self labelAttributesWithFont:fontToSize]];
        int loops = 0;
        while (sizeWithFont.width < self.bounds.size.width && sizeWithFont.height < self.bounds.size.height)
        {
            fontSize = fontSize + 10.0;
            fontToSize = [self.font fontWithSize:fontSize];
            sizeWithFont = [self.text sizeWithAttributes:[self labelAttributesWithFont:fontToSize]];
            loops++;
        }
        loops = 0;
        while (sizeWithFont.width > self.bounds.size.width || sizeWithFont.height > self.bounds.size.height)
        {
            fontSize = fontSize - 1.0;
            fontToSize = [self.font fontWithSize:fontSize];
            sizeWithFont = [self.text sizeWithAttributes:[self labelAttributesWithFont:fontToSize]];
            loops++;
        }
        self.font = [self.font fontWithSize:fontSize];
    }else{
        self.font = [self.font fontWithSize:0.0];
    }
    self.dynamicallySizing = NO;
    self.updateFontSize = NO;
    
}

-(NSDictionary *)labelAttributesWithFont:(UIFont *)font
{
    NSMutableParagraphStyle *labelParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    labelParagraphStyle.alignment = self.textAlignment;
    labelParagraphStyle.lineBreakMode = NSLineBreakByClipping;
    
    NSShadow *textShadow;
    if(self.shadowColor)
    {
        textShadow = [[NSShadow alloc] init];
        textShadow.shadowColor = self.shadowColor;
        textShadow.shadowOffset = self.shadowOffset;
    }
    
    NSDictionary *attributeDict;
    
    if(textShadow)
        attributeDict = @{NSFontAttributeName : font, NSForegroundColorAttributeName : self.textColor, NSParagraphStyleAttributeName : labelParagraphStyle, NSShadowAttributeName : textShadow};
    else
        attributeDict = @{NSFontAttributeName : font, NSForegroundColorAttributeName : self.textColor, NSParagraphStyleAttributeName : labelParagraphStyle};
    
    return attributeDict;
}

CGFloat positionOfRect(CGFloat length, CGFloat container, NSInteger alignment)
{
    //alignment: 0 == Beginning 1 == middle 2 == end
    CGFloat position;
    
    switch (alignment) {
        case 0:{
            position = 0.0;
            break;
        }
        case 1: {
            CGFloat scale = [UIScreen mainScreen].scale;
            position = ceilf(((container / 2.0) - (length / 2.0)) * scale) / scale;
            break;
        }
        case 2: {
            position = container - length;
        }
        default:
            break;
    }
    
    return position;
}

#pragma mark - Animation

#define LETTER_FLIP_DURATION 0.7

-(void)setTextWithFlipAnimationDuration:(NSTimeInterval)duration text:(NSString *)text completion:(void (^)(BOOL))completionHandler
{
    self.text = text;
    if(text.length > 0 && self.hasRendered)
    {
        UIView *textLabelBeforeSnapshot = [self snapshotViewAfterScreenUpdates:NO];
        textLabelBeforeSnapshot.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        [self addSubview:textLabelBeforeSnapshot];
        
        
        NSArray *letterImageViews = [self positionedImageViewsOfLettersInLabel];
        
        if(self.isAnimating)
        {
            [self.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
            [self removePositionedImageViewsInArray:self.subviews];
        }
        
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
            textLabelBeforeSnapshot.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [textLabelBeforeSnapshot removeFromSuperview];
        }];
        
        int currentCount = 0;
        for(UIImageView *letterView in letterImageViews)
        {
            [self addSubview:letterView];
            letterView.alpha = 0.0;
            
            CGRect originalFrame = letterView.frame;
            letterView.layer.anchorPoint = CGPointMake(0.5, 1.0);
            letterView.frame = originalFrame;
            letterView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0);
            
            CGFloat lettersCount = [letterImageViews count];
            CGFloat calcDelay = MAX(0.0, (MAX(duration - LETTER_FLIP_DURATION, 0.05)) * (currentCount / lettersCount));
            
            [UIView animateWithDuration:LETTER_FLIP_DURATION delay:calcDelay usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
                letterView.alpha = 1.0;
                letterView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if(letterView == [letterImageViews lastObject])
                {
                    if(finished)
                    {
                        self.isAnimating = NO;
                        [self setNeedsDisplay];
                        [self removePositionedImageViewsInArray:letterImageViews];
                    }
                    completionHandler(finished);
                }
            }];
            currentCount++;
        }
    }else{
        completionHandler(YES);
    }
}

-(NSArray *)positionedImageViewsOfLettersInLabel
{
    UIImage *textLabelImage = [self snapshotOfUpdatedTextLabel];
    
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    //Need to do this to support animation of emoticons. The bytes do not get read correctly with the length property and the substring method
    NSData *stringData = [self.text dataUsingEncoding:NSUTF32BigEndianStringEncoding allowLossyConversion:NO];
    
    NSUInteger stringDataStringLength = stringLengthWith32Data(stringData);
    
    NSMutableArray *letterImageViews = [[NSMutableArray alloc] initWithCapacity:stringDataStringLength];
    CGFloat previousWidth = 0.0;
    NSString *currentString;
    
    
    
    
    for(int i = 0; i < stringDataStringLength; i++)
    {
        currentString = substringWith32DataInRange(stringData, NSMakeRange(0, i+1));
        
        CGFloat currentStringWidth = [currentString sizeWithAttributes:[self labelAttributesWithFont:self.font]].width;
        currentStringWidth = ceilf(currentStringWidth * textLabelImage.scale) / textLabelImage.scale;
        
        NSString *currentCharString = substringWith32DataInRange(stringData, NSMakeRange(i, 1));
        
        if(![currentCharString isEqualToString:@" "])
        {
            UIImage *currentLetter = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(textLabelImage.CGImage, CGRectMake(previousWidth * textLabelImage.scale, 0.0, currentStringWidth * textLabelImage.scale - previousWidth * textLabelImage.scale, textLabelImage.size.height * textLabelImage.scale)) scale:textLabelImage.scale orientation:UIImageOrientationUp];
            UIImageView *currentLetterImageView = [[UIImageView alloc] initWithImage:currentLetter];
            currentLetterImageView.center = CGPointMake(textRect.origin.x + previousWidth +currentLetterImageView.bounds.size.width / 2.0, textRect.origin.y + currentLetterImageView.bounds.size.height / 2.0);
            [letterImageViews addObject:currentLetterImageView];
        }
        
        previousWidth = currentStringWidth;
    }
    
    return letterImageViews;
}

NSUInteger stringLengthWith32Data(NSData *data)
{
    return data.length / 4;
}

NSString* substringWith32DataInRange(NSData *data, NSRange range)
{
    NSRange dataRange = NSMakeRange(range.location * 4, range.length * 4);
    NSData *substringData = [data subdataWithRange:dataRange];
    NSString *substring = [[NSString alloc] initWithData:substringData encoding:NSUTF32BigEndianStringEncoding];
    return substring;
}

-(UIImage *)snapshotOfUpdatedTextLabel
{
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0.0);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -textRect.origin.x, 0.0);
    
    [self drawText];
    
    UIImage *textSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return textSnapshot;
}

-(void)removePositionedImageViewsInArray:(NSArray *)positionedImageViews
{
    for(UIView *subview in positionedImageViews)
    {
        if([subview isKindOfClass:[UIImageView class]])
        {
            [subview removeFromSuperview];
        }
    }
}

@end

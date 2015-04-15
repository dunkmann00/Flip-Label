//
//  ViewController.m
//  Flip Label
//
//  Created by George Waters on 4/15/15.
//  Copyright (c) 2015 George Waters. All rights reserved.
//

#import "ViewController.h"
#import "GWFlipLabel.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GWFlipLabel *flipLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.flipLabel.textAlignment = NSTextAlignmentCenter;
    self.flipLabel.dynamicFontSize = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.flipLabel setTextWithFlipAnimationDuration:1.0 text:textField.text completion:^(BOOL finished) {
        NSLog(@"Flip Complete!");
    }];
    [textField resignFirstResponder];
    return YES;
}

@end

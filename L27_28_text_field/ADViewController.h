//
//  ADViewController.h
//  L27_28_text_field
//
//  Created by A D on 1/27/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailFieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *phoneFieldOutlet;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldsCollection;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *outputLablesCollection;


@end

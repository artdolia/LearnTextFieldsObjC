//
//  ADViewController.m
//  L27_28_text_field
//
//  Created by A D on 1/27/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController () <UITextFieldDelegate>

@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (UITextField *field in self.textFieldsCollection){
        
        field.delegate = self;
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(handleTextFieldNotifications:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - textfield notifications

- (void) handleTextFieldNotifications:(NSNotification *) field{
    
    [self updateOutputLabelForField:[field object]];
}


#pragma  mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL result = YES;
    
    if ([textField isEqual:self.emailFieldOutlet]) {
        
        result = [self handleEmailImputOf:textField chnagingCharsInRange:range replacingSting:string];
        
    }else if([textField isEqual:self.phoneFieldOutlet]){
        
        result = [self handlePhoneInputOf:textField chnagingCharsInRange:range replacingSting:string];
    }
    
    return result;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [self updateOutputLabelForField:textField];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    
    if([textField isEqual:self.textFieldsCollection.lastObject]){
       
        [textField resignFirstResponder];
    
    }else{
        
        [[self.textFieldsCollection objectAtIndex:[self.textFieldsCollection indexOfObject:textField]+1] becomeFirstResponder];
    }

    return YES;
}


#pragma  mark - handle input

- (BOOL) handleEmailImputOf:(UITextField *)textField chnagingCharsInRange:(NSRange)range replacingSting:(NSString *)string{
    
    static const int emailLength = 20;
    BOOL result = YES;
    
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *tempSet = [NSCharacterSet characterSetWithCharactersInString:@"@."];
    NSMutableCharacterSet *validationSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [validationSet formUnionWithCharacterSet:tempSet];
    [validationSet invert];
    
    NSArray *components = [resultString componentsSeparatedByCharactersInSet:validationSet];
    
    NSArray *atSeparatedComponents = [resultString componentsSeparatedByString:@"@"];
    
    if([components count] > 1 || [atSeparatedComponents count] > 2 || [resultString length] > emailLength){
        result = NO;
    }
    
    return result;
}

- (BOOL) handlePhoneInputOf:(UITextField *)textField chnagingCharsInRange:(NSRange)range replacingSting:(NSString *)string{
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return  NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return  NO;
    }
    
    NSMutableString *resultString = [NSMutableString string];
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);

    if(localNumberLength > 0){
        
        NSString *number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        [resultString appendString:number];
        
        if([resultString length] > 3){
            
            [resultString insertString:@"-" atIndex:3];
        }
    }

    if([newString length] > localNumberLength){
        
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString *area = [newString substringWithRange:areaRange];
        area = [NSString stringWithFormat:@"(%@) ", area];
        [resultString insertString:area atIndex:0];
    }

    if([newString length] > localNumberMaxLength + areaCodeMaxLength){
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        NSString *countryCode = [newString substringWithRange:countryCodeRange];
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    [self updateOutputLabelForField:textField];
    
    return NO;
}

#pragma mark - set current outputLabel

- (UILabel*) updateOutputLabelForField:(UITextField*)field{
    
    UILabel *outputLabel = [self.outputLablesCollection objectAtIndex:[self.textFieldsCollection indexOfObject:field]];
    outputLabel.text = field.text;
    
    return outputLabel;
}

@end

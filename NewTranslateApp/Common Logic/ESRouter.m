//
//  ESRouter.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESRouter.h"

@implementation ESRouter

+ (UIViewController *)languagesPicker
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LanguagesPicker" bundle:[NSBundle mainBundle]];
    UIViewController *langPicker = [storyboard instantiateViewControllerWithIdentifier:@"ESLanguagesPickerViewController"];
    langPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    langPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    return langPicker;
}

@end

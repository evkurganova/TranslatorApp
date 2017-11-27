//
//  ESAppSettings.m
//  TranslateApp
//
//  Created by Ekaterina Kurganova on 15.03.15.
//  Copyright (c) 2015 Ekaterina Kurganova. All rights reserved.
//

#import "ESAppSettings.h"

#define DEFAULTS_TRANSLATION_LANGUAGE @"DEFAULTS_TRANSLATION_LANGUAGE"

@implementation ESAppSettings

+(NSString *)translationLanguage
{
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_TRANSLATION_LANGUAGE];
    
    if(code)
    {
        return code;
    }
    else
    {
        return @"en";
    }
}

+(void)setTranslationLanguage:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:DEFAULTS_TRANSLATION_LANGUAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end

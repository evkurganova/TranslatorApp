//
//  ESAppSettings.h
//  TranslateApp
//
//  Created by Ekaterina Kurganova on 15.03.15.
//  Copyright (c) 2015 Ekaterina Kurganova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESAppSettings : NSObject

+(NSString *)translationLanguage;
+(void)setTranslationLanguage:(NSString *)code;

@end

//
//  ESTranslateManager.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class Word;
@class Language;

@interface ESTranslationManager : AFHTTPSessionManager

+ (ESTranslationManager *)shared;

+ (void)translationForWord:(NSString *)nativeWord completion:(void(^)(BOOL success, NSError *error, Word *word))completion;

+ (void)languages:(void(^)(BOOL success, NSError *error, NSArray<Language *> *languages))completion;

@end

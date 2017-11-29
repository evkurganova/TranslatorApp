//
//  ESDataManager.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Word;
@class Language;

@interface ESDataManager : NSObject

#pragma mark - Languages

+ (void)saveLanguagesFromDictionary:(NSDictionary *)dictionary completion:(void(^)(BOOL success, NSError *error))completion;
+ (Language *)currentLanguage;
+ (void)setCurrentLanguage:(Language *)language completion:(void(^)(BOOL success, NSError *error))completion;
+ (NSArray<Language *> *)allLanguages;

#pragma mark - Words

+ (void)createWord:(NSString *)nativeWord completion:(void(^)(BOOL success, NSError *error))completion;
+ (void)saveWord:(NSString *)nativeWord fromDictionary:(NSDictionary *)dictionary completion:(void(^)(BOOL success, NSError *error))completion;
+ (NSArray<Word *> *)allWords;
+ (void)deleteWord:(Word *)word completion:(void(^)(BOOL success, NSError *error))completion;

@end

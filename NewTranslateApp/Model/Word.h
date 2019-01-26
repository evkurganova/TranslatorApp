//
//  Word+CoreDataProperties.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Language;

@interface Word : NSManagedObject

@property (nullable, nonatomic, strong) NSString *nativeWord;
@property (nullable, nonatomic, strong) NSDate *changedDate;
@property (nullable, nonatomic, strong) NSString *translatedWord;
@property (nullable, nonatomic, strong) Language *language;

+ (void)createWord:(NSString *_Nonnull)nativeWord completion:(void(^_Nullable)(BOOL success, NSError * _Nullable error))completion;
+ (void)saveWord:(NSString *_Nonnull)nativeWord fromDictionary:(NSDictionary *_Nonnull)dictionary completion:(void(^_Nullable)(BOOL success, NSError * _Nullable error))completion;
+ (void)deleteWord:(Word *_Nonnull)word completion:(void(^_Nullable)(BOOL success, NSError *_Nullable error))completion;

+ (NSArray<Word *> *_Nullable)allWords;
+ (NSArray<Word *> *)allWordsWithText:(NSString *)searchText;

@end


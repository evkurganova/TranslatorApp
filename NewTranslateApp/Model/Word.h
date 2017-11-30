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

+ (void)createWord:(NSString *)nativeWord completion:(void(^)(BOOL success, NSError *error))completion;
+ (void)saveWord:(NSString *)nativeWord fromDictionary:(NSDictionary *)dictionary completion:(void(^)(BOOL success, NSError *error))completion;
+ (void)deleteWord:(Word *)word completion:(void(^)(BOOL success, NSError *error))completion;

+ (NSArray<Word *> *)allWords;
+ (NSArray<Word *> *)allWordsWithPredicate:(NSPredicate *)predicate;

@end


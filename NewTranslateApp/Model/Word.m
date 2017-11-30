//
//  Word+CoreDataProperties.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import "Word.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Language.h"

@implementation Word

@dynamic nativeWord;
@dynamic changedDate;
@dynamic translatedWord;
@dynamic language;

+ (void)createWord:(NSString *)nativeWord completion:(void(^)(BOOL success, NSError *error))completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        Language *lang = [Language currentLanguageInContext:localContext];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nativeWord == %@ AND language == %@", nativeWord, lang];
        Word *word = [Word MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!word) {
            word = [Word MR_createEntityInContext:localContext];
            word.nativeWord = nativeWord;
            word.language = lang;
            word.changedDate = [NSDate date];
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(contextDidSave, error);
        }
    }];
}

+ (void)saveWord:(NSString *)nativeWord fromDictionary:(NSDictionary *)dictionary completion:(void(^)(BOOL success, NSError *error))completion {
    
    NSArray *textArray = dictionary[@"text"];
    NSString *translationCodeLanguage = dictionary[@"lang"];
    NSString *languageID = [translationCodeLanguage substringWithRange:NSMakeRange(3, 2)];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        Language *lang = [Language MR_findFirstByAttribute:@"languageID" withValue:languageID inContext:localContext];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nativeWord == %@ AND language == %@", nativeWord, lang];
        Word *word = [Word MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!word) {
            word = [Word MR_createEntityInContext:localContext];
        }
        word.nativeWord = nativeWord;
        word.translatedWord = [textArray firstObject];
        word.language = lang;
        word.changedDate = [NSDate date];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(contextDidSave, error);
        }
    }];
}

+ (void)deleteWord:(Word *)word completion:(void(^)(BOOL success, NSError *error))completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        [word MR_deleteEntityInContext:localContext];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (completion) {
            completion(contextDidSave, error);
        }
    }];
}

+ (NSArray<Word *> *)allWords {
    
    return [Word MR_findAllSortedBy:@"changedDate" ascending:NO];
}

+ (NSArray<Word *> *)allWordsWithPredicate:(NSPredicate *)predicate {
    
    return [Word MR_findAllSortedBy:@"changedDate" ascending:NO withPredicate:predicate];
}

@end

//
//  ESDataManager.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESDataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Word.h"
#import "Language.h"

@implementation ESDataManager

#pragma mark - Languages

+ (void)saveLanguagesFromDictionary:(NSDictionary *)dictionary completion:(void(^)(BOOL success, NSError *error))completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        Language *currentLanguage = [ESDataManager currentLanguageInContext:localContext];
        
        for (NSString *langCode in dictionary.allKeys) {
            
            Language *lang = [Language MR_findFirstByAttribute:@"languageID" withValue:langCode];
            if (!lang) {
                lang = [Language MR_createEntityInContext:localContext];
            }
            lang.languageID = langCode;
            lang.name = dictionary[langCode];
            lang.isCurrent = @([lang.languageID isEqualToString:currentLanguage.languageID]);
            
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(contextDidSave, error);
        }
    }];
}

+ (Language *)currentLanguage {
    
    return [ESDataManager currentLanguageInContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (Language *)currentLanguageInContext:(NSManagedObjectContext *)context {
    
    Language *lang = [Language MR_findFirstByAttribute:@"isCurrent" withValue:@(YES) inContext:context];
    if (lang) {
        return lang;
    } else {
        lang = [Language MR_createEntityInContext:context];
        lang.languageID = @"en";
        lang.name = @"Английский";
        lang.isCurrent = @(YES);
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        return lang;
    }
}

+ (void)setCurrentLanguage:(Language *)language completion:(void(^)(BOOL success, NSError *error))completion {
    
    Language *oldCurrentLanguage = [ESDataManager currentLanguageInContext:language.managedObjectContext];

    oldCurrentLanguage.isCurrent = @(NO);
    language.isCurrent = @(YES);
    
    [language.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (completion) {
            completion(contextDidSave, error);
        }
    }];
}

+ (NSArray<Language *> *)allLanguages {
    
    return [Language MR_findAllSortedBy:@"name" ascending:YES];
}

#pragma mark - Words

+ (void)createWord:(NSString *)nativeWord completion:(void(^)(BOOL success, NSError *error))completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        Language *lang = [ESDataManager currentLanguageInContext:localContext];

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

@end

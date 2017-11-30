//
//  Language+CoreDataProperties.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import "Language.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Language

@dynamic languageID;
@dynamic name;
@dynamic isCurrent;
@dynamic words;

+ (void)saveLanguagesFromDictionary:(NSDictionary *)dictionary completion:(void(^)(BOOL success, NSError *error))completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        Language *currentLanguage = [Language currentLanguageInContext:localContext];
        
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
    
    return [Language currentLanguageInContext:[NSManagedObjectContext MR_defaultContext]];
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
    
    Language *oldCurrentLanguage = [Language currentLanguageInContext:language.managedObjectContext];
    
    oldCurrentLanguage.isCurrent = @(NO);
    language.isCurrent = @(YES);
    
    [language.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCurrentLanguageChanged object:nil];

        if (completion) {
            completion(contextDidSave, error);
        }
    }];
}

+ (NSArray<Language *> *)allLanguages {
    
    return [Language MR_findAllSortedBy:@"name" ascending:YES];
}

@end

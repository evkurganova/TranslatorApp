//
//  Language+CoreDataProperties.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

static NSString * _Nonnull const kNotificationCurrentLanguageChanged = @"kNotificationCurrentLanguageChanged";

@interface Language : NSManagedObject

@property (nullable, nonatomic, strong) NSString *languageID;
@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSNumber *isCurrent;
@property (nullable, nonatomic, strong) NSSet<Word*> *words;

+ (void)saveLanguagesFromDictionary:(NSDictionary *_Nullable)dictionary completion:(void(^_Nullable)(BOOL success, NSError * _Nullable error))completion;

+ (Language *_Nonnull)currentLanguage;
+ (Language *_Nonnull)currentLanguageInContext:(NSManagedObjectContext *_Nonnull)context;
+ (void)setCurrentLanguage:(Language *_Nullable)language completion:(void(^_Nullable)(BOOL success, NSError * _Nullable error))completion;

+ (NSArray<Language *> *_Nullable)allLanguages;

@end

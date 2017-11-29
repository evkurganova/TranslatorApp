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

@interface Language : NSManagedObject

@property (nullable, nonatomic, strong) NSString *languageID;
@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSNumber *isCurrent;
@property (nullable, nonatomic, strong) NSSet<Word*> *words;

@end

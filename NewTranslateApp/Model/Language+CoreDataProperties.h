//
//  Language+CoreDataProperties.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import "Language+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Language (CoreDataProperties)

+ (NSFetchRequest<Language *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *languageID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Word *words;

@end

NS_ASSUME_NONNULL_END

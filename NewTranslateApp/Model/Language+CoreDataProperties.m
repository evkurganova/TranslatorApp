//
//  Language+CoreDataProperties.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import "Language+CoreDataProperties.h"

@implementation Language (CoreDataProperties)

+ (NSFetchRequest<Language *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Language"];
}

@dynamic languageID;
@dynamic name;
@dynamic words;

@end

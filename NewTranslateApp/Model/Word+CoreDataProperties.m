//
//  Word+CoreDataProperties.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import "Word+CoreDataProperties.h"

@implementation Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Word"];
}

@dynamic nativeWord;
@dynamic priority;
@dynamic translatedWord;
@dynamic language;

@end

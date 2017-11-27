//
//  Word+CoreDataProperties.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//
//

#import "Word+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nativeWord;
@property (nonatomic) int64_t priority;
@property (nullable, nonatomic, copy) NSString *translatedWord;
@property (nullable, nonatomic, retain) Language *language;

@end

NS_ASSUME_NONNULL_END

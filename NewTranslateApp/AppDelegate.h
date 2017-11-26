//
//  AppDelegate.h
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 26.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


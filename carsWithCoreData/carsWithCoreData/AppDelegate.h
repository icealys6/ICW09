//
//  AppDelegate.h
//  carsWithCoreData
//
//  Created by shfrc101b8 on 2016-12-06.
//  Copyright © 2016 shfrc101b8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


//
//  Users+CoreDataProperties.h
//  LoginLogout
//
//  Created by ChenMo on 4/6/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Users+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Users (CoreDataProperties)

+ (NSFetchRequest<Users *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END

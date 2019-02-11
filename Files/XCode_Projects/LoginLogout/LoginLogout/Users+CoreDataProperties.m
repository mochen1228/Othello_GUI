//
//  Users+CoreDataProperties.m
//  LoginLogout
//
//  Created by ChenMo on 4/6/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Users+CoreDataProperties.h"

@implementation Users (CoreDataProperties)

+ (NSFetchRequest<Users *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Users"];
}

@dynamic username;
@dynamic password;

@end

//
//  Users.h
//  LoginLogout
//
//  Created by ChenMo on 4/8/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#ifndef Users_h
#define Users_h

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Users : NSManagedObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

#endif /* Users_h */

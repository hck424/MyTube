//
//  Search+CoreDataProperties.m
//  
//
//  Created by 김학철 on 2020/05/28.
//
//

#import "Search+CoreDataProperties.h"

@implementation Search (CoreDataProperties)

+ (NSFetchRequest<Search *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Search"];
}

@dynamic keyword;
@dynamic date;
@dynamic fixed;

@end

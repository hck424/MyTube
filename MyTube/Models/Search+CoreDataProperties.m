//
//  Search+CoreDataProperties.m
//  
//
//  Created by 김학철 on 2020/05/22.
//
//

#import "Search+CoreDataProperties.h"

@implementation Search (CoreDataProperties)

+ (NSFetchRequest<Search *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Search"];
}

@dynamic date;
@dynamic keyword;
@dynamic fixed;

@end

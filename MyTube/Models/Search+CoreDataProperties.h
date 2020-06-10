//
//  Search+CoreDataProperties.h
//  
//
//  Created by 김학철 on 2020/05/28.
//
//

#import "Search+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Search (CoreDataProperties)

+ (NSFetchRequest<Search *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *keyword;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL fixed;

@end

NS_ASSUME_NONNULL_END

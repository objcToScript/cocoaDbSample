#import "clsFMDB.h"

@interface clsFMDB (commit)

-(void)_alertError:(NSError*)error;

-(void)_close;

-(void)_open;

-(void)_beginTransaction;

-(void)_commit;

-(void)_rollback;

-(void)_vacuum;

-(int)_lastId;

-(void)_setOnForeignKey;

-(void)_setOffForeignKey;

-(void)_end;

-(void)_setCacheSize:(int32_t)mega;

//-(int)_count:(NSString*)sql;

@end


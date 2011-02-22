@class Recipe;
@class RecipesTableViewController;

@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    Recipe *recipe;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, retain) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
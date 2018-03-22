#import "FTBaseAssetRenderer.h"


NS_ASSUME_NONNULL_BEGIN

@interface FTImageAssetRenderer : FTBaseAssetRenderer

@property (nonatomic, readonly, nullable) UIImage *sourceImage;

@end

@interface FTBaseAssetRenderer (FTPDFAssetRenderer)

+ (FTImageAssetRenderer *)rendererForImageNamed:(NSString *)imageName withExtension:(NSString *)extName;

@end

NS_ASSUME_NONNULL_END

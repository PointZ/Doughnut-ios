#import "TPOSExportKeyStoreNoteView.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSWalletModel.h"
#import "NSString+TPOS.h"
#import "TPOSLocalizedHelper.h"

#import <Toast/Toast.h>

#import "KeyStoreFile.h"
#import "KeyStore.h"
#import "NAChloride.h"
#import "Wallet.h"
#import "Seed.h"
#import <CoreImage/CoreImage.h>


@interface TPOSExportKeyStoreNoteView()

@property (weak, nonatomic) IBOutlet UIView *warningView;

@property (weak, nonatomic) IBOutlet UIView *keyView;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UIButton *copyyButton;
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;
@property (nonatomic, strong) TPOSWalletModel *walletModel;

@end

@implementation TPOSExportKeyStoreNoteView

+ (TPOSExportKeyStoreNoteView *)exportKeyStoreNoteViewWithWalletModel:(TPOSWalletModel *)walletModel {
    TPOSExportKeyStoreNoteView *exportKeyStoreNoteView = [[NSBundle mainBundle] loadNibNamed:@"TPOSExportKeyStoreNoteView" owner:nil options:nil].firstObject;
    exportKeyStoreNoteView.walletModel = walletModel;
    
    return exportKeyStoreNoteView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.warningView.layer.borderWidth = 1;
    self.warningView.layer.borderColor = [UIColor colorWithHex:0xD81400].CGColor;
    self.warningView.layer.cornerRadius = 5;
    self.keyView.layer.cornerRadius = 5;
    self.copyyButton.layer.cornerRadius = 5;
    self.layer.cornerRadius = 5;
    
    //CGFloat heightAddtion = (0-17);
    //self.frame = CGRectMake(0, 0, kScreenWidth - 40, CGRectGetHeight(self.frame) + heightAddtion);
}

- (IBAction)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",_keyLabel.text]];
    [self.window makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_to_board"]];
    _copyyButton.userInteractionEnabled = NO;
    [_copyyButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copied"] forState:UIControlStateNormal];
    _copyyButton.backgroundColor = [[UIColor colorWithHex:0x289FE0] colorWithAlphaComponent:0.5];
}

- (IBAction)closeAction {
    [super hide];
}

- (void)setWalletModel:(TPOSWalletModel *)walletModel {
    _walletModel = walletModel;
    
    NAChlorideInit();
    NSString *secret = [walletModel.privateKey tb_encodeStringWithKey:walletModel.password];
    Seed * seed = [Seed alloc];
    Keypairs *keypairs = [seed deriveKeyPair:secret];
    Wallet *wallet = [[Wallet alloc]initWithKeypairs:keypairs private:secret];
    
    KeyStoreFileModel *keyStoreFile = [KeyStore createLight:walletModel.password wallet:wallet];
    
    _keyLabel.text = [keyStoreFile toJSONString];

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [_keyLabel.text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    
    self.QRImage.image = [UIImage imageWithCIImage:outputImage];
    
    //CGSize size = [_keyLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    //CGFloat heightAddtion = (size.height-33.5);
    //self.frame = CGRectMake(0, 0, kScreenWidth - 40, CGRectGetHeight(self.frame) + heightAddtion);
}

@end


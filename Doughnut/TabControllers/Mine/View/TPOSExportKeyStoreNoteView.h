//
//  TPOSExportKeyStoreNoteView.h
//  Doughnut
//
//  Created by jch01 on 2019/10/23.
//  Copyright © 2019 jch. All rights reserved.
//

#import "TPOSAlertView.h"

@class TPOSWalletModel;

@interface TPOSExportKeyStoreNoteView : TPOSAlertView

+ (TPOSExportKeyStoreNoteView *)exportKeyStoreNoteViewWithWalletModel:(TPOSWalletModel *)walletModel;

@end

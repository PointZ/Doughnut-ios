//
//  WalletManage.h
//  Doughnut
//
//  Created by xumingyang on 2019/8/7.
//  Copyright © 2019 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocketUtility.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"
#import "Wallet.h"
#import "Remote.h"
#import "WalletUserDefaults.h"

@interface WalletManage : NSObject
{
    WalletUserDefaults *walletInfo;
    Remote *remote;
}

//初始化
- (instancetype) initWalletMange;
//创建连接
- (Remote *) createRemote;
//创建钱包（不传私钥）
- (void) createWallet;
//创建钱包（传私钥）
- (void) createWalletWithSecret:(NSString *) secret;
//转账
- (void) transferWithPassword;
//获取余额
- (void) getBalance;
//获取交易记录
- (void) getTansferHishory:(NSUnit *) limit;

@end


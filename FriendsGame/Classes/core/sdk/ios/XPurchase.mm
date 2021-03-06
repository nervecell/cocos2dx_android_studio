#import "SDKCenter.h"
#include "XPurchase.h"

@interface PurchaseSDKCallback : NSObject<PurchaseSDKDelegate>{
    
}

@property (nonatomic, assign) Purchase* purchase;

-(id)initWithPurchase:(Purchase*)purchase;

-(void)didPurchaseFinish:(NSString*)error;

@end

@implementation PurchaseSDKCallback

-(id)initWithPurchase:(Purchase*)purchase{
    if(self = [super init]){
        self.purchase = purchase;
    }
    return self;
}

-(void)didPurchaseFinish:(NSString*)error{
    if(nullptr == self.purchase)
        return;
    PurchaseDelegate* _delegate = self.purchase->getDelegate();
    if(nullptr == _delegate)
        return;
    
    const char* szError = [error UTF8String];
    if(szError && (szError[0] == 0))
        szError = nullptr;
    
    _delegate->didPurchaseFinish(szError);
}

@end


static std::string s_empty;

NSString* safeString2NSString(const char* str){
    if(nullptr == str){
        return [NSString stringWithUTF8String:""];
    }
    else{
        return [NSString stringWithUTF8String:str];
    }
}

Purchase::Purchase(){
    m_delegate = nullptr;
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.delegate = [[PurchaseSDKCallback alloc] initWithPurchase:this];
}

Purchase::~Purchase(){
}

void Purchase::prepare(){
    PurchaseSDK* purchase = [OCSDKCenter purchase];
    [purchase prepareSDK];
}

bool Purchase::isDefault(){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    return purchaseSDK.isDefault;
}

void Purchase::startPurchase(){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK startPurchase];
}

void Purchase::setOrderSerial(const char* orderSerial){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.orderSerial = safeString2NSString(orderSerial);
}

void Purchase::setPrice(float price){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.price = price;
}

void Purchase::setPayId(const char* payId){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.payid = safeString2NSString(payId);
}

void Purchase::setGameUserServer(const char* gameUserServer){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.gameUserServer = safeString2NSString(gameUserServer);
}

void Purchase::setName(const char* name){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.name = safeString2NSString(name);
}

void Purchase::setGameUserId(const char* userId){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.gameUserId = safeString2NSString(userId);
}

void Purchase::setGameUserName(const char* userName){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.gameUserName = safeString2NSString(userName);
}

void Purchase::setPayUrl(const char* payUrl){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.payUrl = safeString2NSString(payUrl);
}

void Purchase::setProductType(const char* szProductType){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.productType = safeString2NSString(szProductType);
}

void Purchase::setProductId(const char* productId){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.productId = safeString2NSString(productId);
}

const char* Purchase::getOtherInfo(const char* key){
    return s_empty.c_str();
}

void Purchase::setOtherInfo(const char* key, const char* value){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK setOtherInfo:key value:value];
}

void Purchase::callFuntionBegin(){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK callFuntionBegin];
}

void Purchase::addFunctionParam(const char* key, const char* value){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK addFunctionParam:key value:value];
}

void Purchase::callFunction(const char* name){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK callFunction:safeString2NSString(name)];
}

void Purchase::callFunctionEnd(){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK callFunctionEnd];
}

void Purchase::setDefaultPurchaseClass(const char* className){
    [[OCSDKCenter purchase] clear];
    //[SDKCenter setDefaultPurchaseClass :[NSString stringWithUTF8String:className]];
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    purchaseSDK.delegate = [[PurchaseSDKCallback alloc] initWithPurchase:this];
}

void Purchase::setSyncParam(const char* key, const char* value){
    if(key && value){
        PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
        [purchaseSDK setSyncParam:[NSString stringWithUTF8String:key] value:[NSString stringWithUTF8String:value]];
    }
}

const char* Purchase::getSyncParam(const char* key){
    if(nullptr == key)
        return s_empty.c_str();
    
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    NSString* value = [purchaseSDK getSyncParam:[NSString stringWithUTF8String:key]];
    return value ? s_empty.c_str() : [value UTF8String];
}

std::map<std::string, std::string> Purchase::getAllSyncParam(){
    std::map<std::string, std::string> allSync;
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    NSDictionary* dic = [purchaseSDK getAllSyncParam];
    NSArray* allKey = [dic allKeys];
    for(NSInteger i = 0; i < [allKey count]; i++){
        NSString* key = (NSString*)[allKey objectAtIndex:i];
        const char* szKey = [key UTF8String];
        NSString* value = (NSString*)[dic objectForKey:key];
        const char* szValue = [value UTF8String];
        allSync.insert(make_pair(szKey, szValue));
    }
    return allSync;
}

void Purchase::cleanSyncParam(){
    PurchaseSDK* purchaseSDK = [OCSDKCenter purchase];
    [purchaseSDK cleanSyncParam];
}


PurchaseDelegate* Purchase::getDelegate(){
    return m_delegate;
}

void Purchase::setDelegate(PurchaseDelegate* _delegate){
    PurchaseDelegate* oldDelegate = m_delegate;
    m_delegate = _delegate;
    if (m_delegate){
        Ref* obj =	dynamic_cast<Ref*>(m_delegate);
        if (obj)
            obj->retain();
    }
    
    if (oldDelegate){
        Ref* obj = dynamic_cast<Ref*>(m_delegate);
        if (obj)
            obj->release();
        else
            delete oldDelegate;
    }
}

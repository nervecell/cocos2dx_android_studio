#ifndef X_ACCOUNT_H
#define X_ACCOUNT_H
#include <string>
#include <map>
#include <vector>
using namespace std;
#include "cocos2d.h"
using namespace cocos2d;

typedef enum _AccountToolBarPlace{
    
    ToolBarAtTopLeft = 1,   /* 左上 */
    
    ToolBarAtTopRight,      /* 右上 */
    
    ToolBarAtMiddleLeft,    /* 左中 */
    
    ToolBarAtMiddleRight,   /* 右中 */
    
    ToolBarAtBottomLeft,    /* 左下 */
    
    ToolBarAtBottomRight,   /* 右下 */
    
}AccountToolBarPlace;

typedef enum _AccountLogoutFrom
{
	LogoutFromManual = 1,
	LogoutFromAuto = 2
}AccountLogoutFrom;

class X_CORE_DLL AccountDelegate{

public:

	virtual void didLoginFinished(const char* error){}

    virtual void didLoginCancel(){}

	virtual void didLogoutFinished(AccountLogoutFrom from){}

	virtual ~AccountDelegate(){}
};


class X_CORE_DLL Account : public Ref
{
    
public:
    
    Account();
    
    virtual ~Account();
    
	void prepare();

    void clean();
    
	bool isDefault();

	bool hasUserCenter();

public:
    
    const char* getName();
    
    const char* getId();
    
	const char* getSessionId();
	
    const char* getGender();
    
    const char* getFirstName();
    
    const char* getLastName();
    
    const char* getLocale();
    
    const char* getEmail();
    
    const char* getProfileImage();
 
    const char* getChannelId();
    
    const char* getChannelName();
	
	const char* getAppId();

	const char* getAppKey();

public:
    
    void login();
    
    void logout();
    
    void swtichAccount();
    
    void gotoUserCetner();
    
    void gotoBBS();
    
    void gotoEnterAPPCetner();
    
    void showToolbar(bool visible);
    
    void showToolbar(bool visible, AccountToolBarPlace place );
    
    void setDefaultAccountSDKByClassName(const char* className);
    
public:
    
    const char* getOtherInfo(const char* key);
    
    void setOtherInfo(const char* key, const char* value);
    
    void callFuntionBegin();
    
    void addFunctionParam(const char* key, const char* value);
    
    void callFunction(const char* name);
    
    void callFunctionEnd();
    
public:

	void setSyncParam(const char* key, const char* value);

	const char* getSyncParam(const char* key);

	std::map<std::string, std::string> getAllSyncParam();

	void cleanSyncParam();
	
public:
    
    void setDelegate(AccountDelegate* _delegate);
    
    AccountDelegate* getDelegate();
    
protected:
    
    AccountDelegate* m_delegate;
};

#endif

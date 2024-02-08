import React, {useEffect} from "react";
import QB from "quickblox/quickblox";
import {
    QuickBloxUIKitProvider,
    QuickBloxUIKitDesktopLayout,
    useQbUIKitDataContext
} from 'quickblox-react-ui-kit';

export default function App(){
    const qbUIKitContext = useQbUIKitDataContext();

    const [isUserAuthorized, setUserAuthorized] = React.useState(false);
    const [isSDKInitialized, setSDKInitialized] = React.useState(false);
    const [QBConfig, setQBConfig] = React.useState({});
    const [currentUserName, setCurrentUserName] = React.useState('');

    const [sessionToken, setSessionToken] = React.useState('');
    async function fetchDataFromMainProcess() {
        try {
            // const data = await window.electronAPI.requestData();
            const data = await electronAPI.requestData();
            setQBConfig(data.config);
            setCurrentUserName(data.currentUserName);
            setSessionToken(data.sessionToken);
        } catch (error) {
            console.error('fetch data from main process error :', error);
        }
    }


    useEffect(() => {
        fetchDataFromMainProcess();
    }, []);

    useEffect(() => {
        if (!sessionToken || sessionToken?.length === 0) return;
        // check if we have installed SDK
        if (typeof window.QB === 'undefined') {
            if (typeof QB !== 'undefined') {
                window.QB = QB;
            } else {
                let QBLib = require('quickblox/quickblox.min');
                window.QB = QBLib;
            }
        }

        if (isSDKInitialized && isUserAuthorized) return;
        QB.initWithAppId(QBConfig.credentials.appId, QBConfig.credentials.accountKey,QBConfig.appConfig);
        console.log('Call on.sessionExpired: ');
        QB.chat.onSessionExpiredListener = function (error) {
            if (error) {
                console.log('onSessionExpiredListener - error: ', error);
            } else {
                console.log('Hello from client app SessionExpiredListener');
            }
        }
        QB.startSessionWithToken(sessionToken, function(err, sessionData){
            if (err){
                console.log('Error startSessionWithToken');
            } else {
                const userId = sessionData.session.user_id;
                const password = sessionData.session.token;
                const paramsConnect = { userId, password };

                QB.chat.connect(paramsConnect, async function (errorConnect, resultConnect) {
                    if (errorConnect) {
                        console.log('Can not connect to chat server: ', errorConnect);
                    } else {
                        const authData = {
                            userId: userId,
                            password: password,
                            userName: currentUserName,
                            sessionToken: sessionData.session.token
                        };
                        console.log(authData);
                        await qbUIKitContext.authorize(authData);
                        setSDKInitialized(true);
                        setUserAuthorized(true);
                    }
                });
            }
        });
    }, [sessionToken]);


    //
        return (
            <div>
            { isSDKInitialized && isUserAuthorized && QBConfig.credentials ?

                    <QuickBloxUIKitProvider
                        maxFileSize={100 * 1000000}
                        accountData={{...QBConfig.credentials}}
                        loginData={{
                            login: currentUserName,
                            password: '',
                        }}
                        qbConfig={{...QBConfig}}
                    >
                        <div>
                            {
                                // React states indicating the ability to render UI
                                <QuickBloxUIKitDesktopLayout uikitHeightOffset={'40px'}/>
                            }
                        </div>
                    </QuickBloxUIKitProvider>
                 :
                <div>wait while SDK is initializing...</div>
}
            </div>
    )
}

// main processing use node js
const {app, BrowserWindow, ipcMain } = require('electron');
const path = require("path");

const userRequiredParams = {
    'login': 'YOUR_LOGIN',
    'password': 'YOUR_PASSWORD'
};
const QBConfig = {
    credentials: {
        appId: -1,
        accountKey: 'YOUR_ACCOUNT_KEY',
        authKey: 'YOUR_AUTH_KEY',
        authSecret: 'YOUR_AUTH_SECRET',
        sessionToken: '',
    },
    configAIApi: {
        AIAnswerAssistWidgetConfig: {
            organizationName: 'Quickblox',
            openAIModel: 'gpt-3.5-turbo',
            apiKey: 'YOUR_OpenAi_API_KEY',
            maxTokens: 3584,
            useDefault: true,
            proxyConfig: {
                api: 'v1/chat/completions',
                servername: 'https://api.openai.com/',
                port: '',
            },
        },
        AITranslateWidgetConfig: {
            organizationName: 'Quickblox',
            openAIModel: 'gpt-3.5-turbo',
            apiKey: 'sYOUR_OpenAi_API_KEY',
            maxTokens: 3584,
            useDefault: true,
            defaultLanguage: 'Ukrainian',
            languages: ['Ukrainian', 'English', 'French', 'Portuguese', 'German'],
            proxyConfig: {
                api: 'v1/chat/completions',
                servername: '',
                port: '',
            },
            // proxyConfig: {
            //   api: 'v1/chat/completions',
            //   servername: 'http://localhost',
            //   port: '3012',
            // },
        },
        AIRephraseWidgetConfig: {
            organizationName: 'Quickblox',
            openAIModel: 'gpt-3.5-turbo',
            apiKey: 'YOUR_OpenAi_API_KEY',
            maxTokens: 3584,
            useDefault: true,
            defaultTone: 'Professional',
            Tones: [
                {
                    name: 'Professional Tone',
                    description:
                        'This would edit messages to sound more formal, using technical vocabulary, clear sentence structures, and maintaining a respectful tone. It would avoid colloquial language and ensure appropriate salutations and sign-offs',
                    iconEmoji: '👔',
                },
                {
                    name: 'Friendly Tone',
                    description:
                        'This would adjust messages to reflect a casual, friendly tone. It would incorporate casual language, use emoticons, exclamation points, and other informalities to make the message seem more friendly and approachable.',
                    iconEmoji: '🤝',
                },
                {
                    name: 'Encouraging Tone',
                    description:
                        'This tone would be useful for motivation and encouragement. It would include positive words, affirmations, and express support and belief in the recipient.',
                    iconEmoji: '💪',
                },
                {
                    name: 'Empathetic Tone',
                    description:
                        'This tone would be utilized to display understanding and empathy. It would involve softer language, acknowledging feelings, and demonstrating compassion and support.',
                    iconEmoji: '🤲',
                },
                {
                    name: 'Neutral Tone',
                    description:
                        'For times when you want to maintain an even, unbiased, and objective tone. It would avoid extreme language and emotive words, opting for clear, straightforward communication.',
                    iconEmoji: '😐',
                },
                {
                    name: 'Assertive Tone',
                    description:
                        'This tone is beneficial for making clear points, standing ground, or in negotiations. It uses direct language, is confident, and does not mince words.',
                    iconEmoji: '🔨',
                },
                {
                    name: 'Instructive Tone',
                    description:
                        'This tone would be useful for tutorials, guides, or other teaching and training materials. It is clear, concise, and walks the reader through steps or processes in a logical manner.',
                    iconEmoji: '📖',
                },
                {
                    name: 'Persuasive Tone',
                    description:
                        'This tone can be used when trying to convince someone or argue a point. It uses persuasive language, powerful words, and logical reasoning.',
                    iconEmoji: '☝️',
                },
                {
                    name: 'Sarcastic/Ironic Tone',
                    description:
                        'This tone can make the communication more humorous or show an ironic stance. It is harder to implement as it requires the AI to understand nuanced language and may not always be taken as intended by the reader.',
                    iconEmoji: '😏',
                },
                {
                    name: 'Poetic Tone',
                    description:
                        'This would add an artistic touch to messages, using figurative language, rhymes, and rhythm to create a more expressive text.',
                    iconEmoji: '🎭',
                },
            ],
            proxyConfig: {
                api: 'v1/chat/completions',
                servername: 'https://api.openai.com/',
                port: '',
            },
        },
    },
    appConfig: {
        maxFileSize: 10 * 1024 * 1024,
        sessionTimeOut: 122,
        chatProtocol: {
            active: 2,
        },
        debug: true,
        enableForwarding: true,
        enableReplying: true,
        regexUserName: '^(?=[a-zA-Z])[-a-zA-Z_ ]{3,49}(?<! )$',
        endpoints: {
            api: 'api.quickblox.com',
            chat: 'chat.quickblox.com',
        },
        streamManagement: {
            enable: true,
        },
    },
};

function createWindow(){
    // renderer processing
    const win = new BrowserWindow({
        width:800,
        height:600,
        backgroundColor: "white",
        // webPreferences: {
        //     nodeIntegration: true
        // }
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            worldSafeExecuteJavaScript: true,
            preload: path.join(__dirname, 'preload.js'),
        }
    });
    win.loadFile('index.html');
    win.webContents.openDevTools({ mode: 'detach' });
}

const createUserSession = () => {
    let QuickBlox = require('quickblox').QuickBlox;
    const QBOther = new QuickBlox();

    const APPLICATION_ID = QBConfig.credentials.appId;
    const AUTH_KEY = QBConfig.credentials.authKey;
    const AUTH_SECRET = QBConfig.credentials.authSecret;
    const ACCOUNT_KEY = QBConfig.credentials.accountKey;
    const CONFIG = QBConfig.appConfig;

    QBOther.init(APPLICATION_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY, CONFIG);

    return new Promise((resolve, reject) => {
        console.log('Create User Session QB.createSession, params ', JSON.stringify(userRequiredParams));
        QBOther.createSession(userRequiredParams, (error, result) => {
            if (error) {
                console.log('createUserSession error in QB.createSession', JSON.stringify(error));
                reject(error);
            } else {
                console.log('createUserSession ok in QB.createSession', JSON.stringify(result));
                resolve(result);
            }
        });
    });
};

async function prepareDataForRenderer() {
    try {
        const session = await createUserSession();
        const data = {config:{ ...QBConfig, credentials: {appId: -1,
                                                            accountKey: 'YOUR_ACCOUNT_KEY',
                                                            authKey: '',
                                                            authSecret: '',
                                                            sessionToken: session.token,},},
                         currentUserName: userRequiredParams.login,
                         sessionToken: session.token};
        return data;
    } catch (error) {
        throw new Error('Ошибка при получении данных: ' + error.message);
    }
}

ipcMain.on('request-data', async (event, arg) => {
    try {
        const data = await prepareDataForRenderer();
        event.reply('response-data', data);
    } catch (error) {
        event.reply('response-error', error.message);
    }
});
app.whenReady().then( () => {
    createWindow();
});


app.on('window-all-closed', ()=>{
    if (process.platform !== 'darwin'){
        app.quit();
    }
})
app.on('activate', ()=>{
    if (BrowserWindow.getAllWindows().length === 0){
        createWindow();
    }
})


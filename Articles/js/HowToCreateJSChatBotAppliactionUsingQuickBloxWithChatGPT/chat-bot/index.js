var QuickBlox = require('quickblox').QuickBlox;
const { Configuration, OpenAIApi } = require('openai');

const configuration = new Configuration({
  apiKey: '<YOUR_OPENAI_API_KEY>',
});
const openai = new OpenAIApi(configuration);


var QB = new QuickBlox();

var APPLICATION_ID = 0;
var AUTH_KEY = '';
var AUTH_SECRET = '';
var ACCOUNT_KEY = '';


QB.init(APPLICATION_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);

QB.createSession((error, result) => {
    if (error) {
      console.log('Create session Error: ', error);
    } else {
      console.log('Create session - DONE!');
      // connect to Chat Server.....

      var userCredentials = {
        userId: 136913749,
        password: 'Test_2023'
      };

      QB.chat.connect(userCredentials, (error, contactList) =>{
        if (error) {
            console.log('QB chat.connect is failed!');
            process.exit(1);
        }        
        console.log('QB Bot is up and running');
        // listener....
        QB.chat.onMessageListener = onMessageListener;
    });


  }
});

async function onMessageListener(userId, msg) {
    if (msg.type === 'chat' && msg.body) {

      const response =  await openai.createCompletion({ 
        model: 'text-davinci-003', 
        prompt: msg.body, 
        temperature: 0.7, 
        max_tokens: 3000, 
      });


          const answerMessage = {
              type: 'chat',
            body: response.data.choices[0].text, 
            extension: {
              save_to_history: 1,
            },
        };

          QB.chat.send(userId, answerMessage);
    }
}



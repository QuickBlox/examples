require('dotenv').config();

var QuickBlox = require('quickblox').QuickBlox;
const OpenAI = require('openai');

const requiredEnvVars = [
  'QB_APPLICATION_ID',
  'QB_AUTH_KEY',
  'QB_AUTH_SECRET',
  'QB_ACCOUNT_KEY',
  'QB_BOT_USER_ID',
  'QB_BOT_PASSWORD',
  'OPENAI_API_KEY',
];

const missingEnvVars = requiredEnvVars.filter((name) => !process.env[name]);

if (missingEnvVars.length) {
  console.error('Missing required environment variables:', missingEnvVars.join(', '));
  console.error('Copy .env.example to .env and fill in your QuickBlox and OpenAI credentials.');
  process.exit(1);
}

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

var QB = new QuickBlox();

var APPLICATION_ID = Number(process.env.QB_APPLICATION_ID || 0);
var AUTH_KEY = process.env.QB_AUTH_KEY || '';
var AUTH_SECRET = process.env.QB_AUTH_SECRET || '';
var ACCOUNT_KEY = process.env.QB_ACCOUNT_KEY || '';
var BOT_USER_ID = Number(process.env.QB_BOT_USER_ID || 0);
var BOT_PASSWORD = process.env.QB_BOT_PASSWORD || '';

QB.init(APPLICATION_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);

QB.createSession((error, result) => {
    if (error) {
      console.log('Create session Error: ', error);
    } else {
      console.log('Create session - DONE!');
      // connect to Chat Server.....

      var userCredentials = {
        userId: BOT_USER_ID,
        password: BOT_PASSWORD,
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
      try {
        const completion =  await openai.chat.completions.create({
          model: 'gpt-4o-mini',
          messages: [
            {
              role: 'system',
              content: 'You are a helpful chatbot inside a QuickBlox chat application. Answer clearly and concisely.',
            },
            {
              role: 'user',
              content: msg.body,
            },
          ],
          temperature: 0.7,
          max_completion_tokens: 500,
        });

        const answerMessage = {
          type: 'chat',
          body: completion.choices[0]?.message?.content?.trim() || 'Sorry, I could not generate a response.',
          extension: {
            save_to_history: 1,
          },
        };

        QB.chat.send(userId, answerMessage);
      } catch (error) {
        console.error('OpenAI request failed:', error);

        QB.chat.send(userId, {
          type: 'chat',
          body: 'Sorry, I am having trouble generating a response right now. Please try again later.',
          extension: {
            save_to_history: 1,
          },
        });
      }
    }
}



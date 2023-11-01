const QBAIRephrase = require('qb-ai-rephrase').QBAIRephrase;

history = [
    { role: "user", content: "Good afternoon. Do you like football?" },
    { role: "assistant", content: "Hello. I've been playing football all my life." },
    { role: "user", content: "Can you please explain the rules of playing football?"}
];

tones = [
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
  ];

const getToneByName = (toneName) => {
    console.log('call getToneByName ...');
    let tone = tones[0];

    if (toneName) {
        for (let index = 0; index < tones.length; index++) {
            if (tones[index].name === toneName) {
                tone = tones[index];
                break;
            }  
        }
    }
    
    if (tone === undefined)
      tone = tones[0];  

    return tone;
}

//Can you please explain the rules of playing football?
//Pouvez-vous s'il vous plaît expliquer les règles du football ?
//Können Sie bitte die Regeln des Fußballspiels erklären?
textToRephrase = "Sure! In football, two teams of 11 players each try to score goals by getting the ball into the opposing team's net. Players can pass, dribble, or shoot the ball to move it around the field. The team with the most goals at the end of the game wins.";

module.exports.aiCreateRephrase = async function (req, res) {
    try {
        const settings = QBAIRephrase.createDefaultAIRephraseSettings();
        settings.apiKey = 'YOUR_API_KEY';
        settings.model = 'gpt-3.5-turbo';
        settings.tone = tones[0]; //Professional Tone
        settings.maxTokens = 3584;

        const result = await QBAIRephrase.rephrase(req.body.text, history, settings);

        res.render('rephrase', {
            title: 'AI Rephrase',
            isRephrase: true,
            history: JSON.stringify(history, null, 4),
            textToRephrase,
            tones,
            result
        });
    } catch (e) {
        res.render('rephrase', {
            title: 'AI Rephrase',
            isRephrase: true,
            history: JSON.stringify(history, null, 4),
            textToRephrase,
            tones,
            result: 'Error rephrase'
        });
    }
}

module.exports.showFormRephrase = async function (req, res) {
    res.render('rephrase', {
        title: 'AI Rephrase',
        isRephrase: true,
        history: JSON.stringify(history, null, 4),
        textToRephrase,
        tones
    });
}

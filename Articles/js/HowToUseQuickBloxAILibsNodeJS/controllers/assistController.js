const QBAIAnswerAssistant = require('qb-ai-answer-assistant-artan').QBAIAnswerAssistant;

history = [
    { role: "user", content: "Good afternoon. Do you like football?" },
    { role: "assistant", content: "Hello. I've been playing football all my life." },
    { role: "user", content: "Can you please explain the rules of playing football?"}
];

//Can you please explain the rules of playing football?
//Pouvez-vous s'il vous plaît expliquer les règles du football ?
//Können Sie bitte die Regeln des Fußballspiels erklären?
//"Можешь, пожалуйста, объяснить правила игры в футбол?"
textToAssist = "Can you please explain the rules of playing football?";

module.exports.aiCreateAnswer = async function (req, res) {
    try {
        const settings = QBAIAnswerAssistant.createDefaultAIAnswerAssistantSettings();
        settings.apiKey = 'YOUR-API-KEY';
        settings.model = 'gpt-3.5-turbo';
    
        settings.maxTokens = 3584;

        const result = await QBAIAnswerAssistant.createAnswer(req.body.text, history, settings);

        res.render('assist', {
            title: 'AI Assist',
            isAssist: true,
            history: JSON.stringify(history, null, 4),
            textToAssist,
            result
        });
    } catch (e) {
        res.render('assist', {
            title: 'AI Assist',
            isAssist: true,
            history: JSON.stringify(history, null, 4),
            textToAssist,
            result: 'Error assist'
        });
    }
}

module.exports.showFormAssist = async function (req, res) {
    res.render('assist', {
        title: 'AI Assist',
        isAssist: true,
        history: JSON.stringify(history, null, 4),
        textToAssist,
    });
}

const QBAITranslate = require('qb-ai-translate').QBAITranslate;

history = [
    { role: "user", content: "Good afternoon. Do you like football?" },
    { role: "assistant", content: "Hello. I've been playing football all my life." }
];

//Can you please explain the rules of playing football?
//Pouvez-vous s'il vous plaît expliquer les règles du football ?
//Können Sie bitte die Regeln des Fußballspiels erklären?
textToTranslate = "Можешь, пожалуйста, объяснить правила игры в футбол?";

module.exports.aiCreateTranslate = async function (req, res) {
    try {
        const settings = QBAITranslate.createDefaultAITranslateSettings();
        settings.apiKey = 'YOUR_API_KEY';
        settings.model = 'gpt-3.5-turbo';
        settings.language = 'Ukrainian';
        //settings.organization = 'QuickBlox';
        settings.maxTokens = 3584;

        settings.language = (req.body.language) ? req.body.language : 'English';

        const result = await QBAITranslate.translate(req.body.text, history, settings);

        res.render('translate', {
            title: 'AI Translate',
            isTranslate: true,
            history: JSON.stringify(history, null, 4),
            textToTranslate,
            result
        });
    } catch (e) {
        res.render('translate', {
            title: 'AI Translate',
            isTranslate: true,
            history: JSON.stringify(history, null, 4),
            textToTranslate,
            result: 'Error translate'
        });
    }
}

module.exports.showFormTranslate = async function (req, res) {
    res.render('translate', {
        title: 'AI Translate',
        isTranslate: true,
        history: JSON.stringify(history, null, 4),
        textToTranslate,
    });
}

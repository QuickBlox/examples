const path = require('path');
const express = require('express');
const exphbs = require('express-handlebars');
const bodyParser = require('body-parser');

const aiAssistRouter = require('./routes/aiAssistRoute');
const aiTranslateRouter = require('./routes/aiTranslateRoute');
const aiRephraseRouter = require('./routes/aiRephraseRoute');
const defaultRouter = require('./routes/defaultRoute');

const app = express();

const hbs = exphbs.create({
  defaultLayout: 'main',
  extname: 'hbs',
  layoutsDir: path.join(__dirname, 'views', 'layouts'),
  partialsDir: path.join(__dirname, 'views', 'layouts', 'partials')
});

app.engine('hbs', hbs.engine);
app.set('view engine', 'hbs');
app.set('views', 'views');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(express.static('public'));

app.use('/ai-assist', aiAssistRouter);
app.use('/ai-translate', aiTranslateRouter);
app.use('/ai-rephrase', aiRephraseRouter);
app.use('/', defaultRouter);

const PORT = process.env.PORT || 3000

app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});

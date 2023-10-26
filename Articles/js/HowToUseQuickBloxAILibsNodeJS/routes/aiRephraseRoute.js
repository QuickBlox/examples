const {Router} = require('express');
const rephraseController =  require('../controllers/rephraseController');

const router = Router();

router.get('/', rephraseController.showFormRephrase);
router.post('/', rephraseController.aiCreateRephrase);

module.exports = router;
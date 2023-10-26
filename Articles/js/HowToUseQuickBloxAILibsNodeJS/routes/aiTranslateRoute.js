const {Router} = require('express');
const translateController =  require('../controllers/translateController');

const router = Router();

router.get('/', translateController.showFormTranslate);
router.post('/', translateController.aiCreateTranslate);

module.exports = router;
const {Router} = require('express');
const assistController =  require('../controllers/assistController');

const router = Router();

router.get('/', assistController.showFormAssist);
router.post('/', assistController.aiCreateAnswer);

module.exports = router;
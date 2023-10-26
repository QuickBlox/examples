const {Router} = require('express');

const router = Router();

router.get('/', (req, res) => {
    res.render('index', {
        title: 'QuickBlox AI libraries',
        isIndex: true
    });
});

module.exports = router;
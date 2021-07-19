import {Router} from 'express';

const router = Router();

router.post('/add-batch',(req,res)=>{
    res.send("working");
});
router.get('/add-batch',(req,res)=>{
    res.send("working");
});

export default router;
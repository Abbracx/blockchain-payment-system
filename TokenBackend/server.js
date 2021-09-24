const Koa = require('koa');
const Router = require('@koa/router');
const cors = require('@koa/cors');
const path = require('path');
const ethers = require('ethers');
const render = require('koa-ejs');
const PaymentProcessor = require('../build/contracts/PaymentProcessor.json');
const { Payment } = require('./db.js');


const app = new Koa(); // creating instance app
const router = new Router(); // creating instance of router


render(app, {
    root: path.join(__dirname, 'views'),
    layout: 'layout',
    viewExt: 'html',
    cache: false,
    debug: false
})


router.get('/getPaymentId/:studentId', getPaymentId);
router.get('/getStudentUrl/:paymentId', getStudentUrl)
router.get('/', index);


async function getPaymentId(ctx){

    let studentId = `uj/2013/ns/${ctx.params.studentId}`;
    const paymentId = (Math.random() * 10000).toFixed(0);

    await Payment.create({
        id: paymentId,
        studentId: studentId,
        paid: false
    });

    ctx.body = `student id is ${studentId}`;
}


async function getStudentUrl(ctx){
    const payment = await Payment.findOne({id: ctx.params.paymentId});
    if(payment && payment.paid === true){
        ctx.body = {
            'Greetings': "Hello EveryOne"
        }
    }
}

async function index(ctx){
   await ctx.render('index',{
        title: "Welcome to the Home page."
   });
}

//router midddleware
app.use(router.routes()).use(router.allowedMethods());

//cors middleware
app.use(cors())

//running server
app.listen(4000,() => console.log("server starting..."));

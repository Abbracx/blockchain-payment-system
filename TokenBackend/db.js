const mongoose = require('mongoose');

const uri = "mongodb+srv://Abbracx:abbracx12345@blockchain-payments.cifvu.mongodb.net/Blockchain-Payments?retryWrites=true&w=majority";

mongoose.connect(
    uri,
    {useNewUrlParser: true, useUnifiedTopology: true}
);

const paymentSchema = new mongoose.Schema({
    id: String,
    studentId: String,
    paid: Boolean
});

const Payment = mongoose.model('Payment', paymentSchema);

module.exports = {
    Payment
}

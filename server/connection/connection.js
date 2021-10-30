const mongoose = require('mongoose');
const URL = "mongodb+srv://harshit:harshit123@cluster0.17m6v.mongodb.net/COURSERIVER?retryWrites=true&w=majority";


const Connection = async() => {
    try {
        await mongoose.connect(URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useFindAndModify: false
        });

        console.log("Database Connected");
    } catch (e) {
        console.log(e);
    }

}


module.exports = Connection;
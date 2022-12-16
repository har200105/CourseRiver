require('dotenv').config();
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const Connection = require('./connection/connection');
require('./models/comment');
app.use(bodyParser());
app.use(express.json());

app.use("/", require('./routes/user'));
app.use("/", require('./routes/course'));


const PORT = process.env.PORT || 4000;

app.listen(PORT, () => {
    console.log("Done");
})
Connection();
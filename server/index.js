const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const Connection = require('./connection/connection');
require('./models/user.js');
require('./models/course.js');
require('./models/comment');
app.use(bodyParser());
app.use(express.json());

app.use("/", require('./routes/routes'));


const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log("Done");
})
Connection();
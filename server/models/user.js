const mongoose = require('mongoose');
const { ObjectId } = mongoose.Schema.Types;
const userSchema = new mongoose.Schema({
   
    email: {
        type: String,
        required: true,
    },

    password: {
        type: String,
        required: true,
    },

    name: {
        type: String,
        required: true,
    },

    image:{
        type:String
    },

    ratingsGiven: [{
        type: ObjectId,
        ref: "Courses"
    }],

    isAdmin:{
        type:Boolean,
        default:false
    },
    verified: {
        type:Boolean,
        default:false
    }

})

const User = mongoose.model("User", userSchema);

module.exports = User;
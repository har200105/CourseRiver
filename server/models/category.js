const mongoose = require('mongoose');
const {ObjectId} = mongoose.Schema.Types;

const categorySchema = mongoose.Schema({
    categoryName:{
        type:String,
        required:true
    },
    categoryPic:{
        type:String,
        required:true
    }
},{timestamps:true});


const Category = mongoose.model("Categories",categorySchema);
module.exports = Category;

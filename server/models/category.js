const mongoose = require('mongoose');

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


const Category = mongoose.model("Category",categorySchema);
module.exports = Category;

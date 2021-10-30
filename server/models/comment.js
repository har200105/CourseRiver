const mongoose = require('mongoose');
const {Schema} = mongoose;
const commentSchema = mongoose.Schema({
    commentedText:{
        type:String,
        required:true
    },
    commentedBy:{
        type:String,
        required:true
    },
    commentedCourse:{
        type:Schema.Types.ObjectId,
        ref:"Courses"
    }
},{timestamps:true});

const Comment = mongoose.model("Comments",commentSchema);
module.exports = Comment;
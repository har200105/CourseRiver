const express = require('express');
const router = express.Router();

const Courses = require("../models/course");
const Comment = require('../models/comment');
const Category = require('../models/category');
const User = require("../models/user");

const reqLogin = require('../middleware/reqLogin');
const reqAdmin = require('../middleware/reqAdmin');


router.get('/allcourses', (req, res) => {
    Courses.find({})
        .sort('-createdAt')
        .populate("comments","commentedText commentedBy")        
        .then(courses => {
            res.status(201).json({ data: courses });
        })
        .catch((err) => {
            console.log(err)
        })
});

router.get('/getTrending', async(req, res) => {
    await Courses.find({ isTrendingCourse: true })
        .sort('-createdAt')
        .populate("comments","commentedText commentedBy")
        .then((course) => {
            res.status(201).json({data:course});
        })
        .catch((err) => {
            console.log(err);
        })
});

router.get('/getHighest',async(req, res) => {
    await Courses.find({ isHighestRated: true })
        .sort('-createdAt')
        .populate("comments","commentedText commentedBy")
        .then(course => {
            res.status(201).json({data:course})
        })
        .catch((e) => {
            console.log(e);
        })
});


router.get('/getRecent', async(req, res) => {
    await Courses.find({ isRecentlyAdded: true })
        .sort('-createdAt')
        .populate("comments","commentedText commentedBy")
        .then(course => {
            res.status(201).json({data:course})
        })
        .catch((e) => {
            console.log(e);
        })
});



router.post('/addCourse', reqLogin,async(req, res) => {
    const course = new Courses(req.body);
    await course.save().then(result => {
        res.status(201).json(result);
    }).catch((e) => {
        console.log(e);
    });
});


router.post('/addReqCourse',reqLogin,async(req,res)=>{
    const {courseName,courseDescription,coursePic,channelName,courseUrl,courseRatings,category} = req.body;
    if(!courseName || !courseDescription || !coursePic || !channelName || !courseUrl){
        res.status(401).json({message:"Please Add All The Feilds"})
    }
    else{
    const isAccepted=false;
    const userCourse = new Courses({
        courseName,
        courseDescription,
        coursePic,
        channelName,
        courseUrl,
        courseRatings,
        isAccepted,
        category
    });
    await userCourse.save().then((s)=>{
        res.status(201).json(s)
    })
}
});




router.put('/ratecourse', reqLogin, async (req, res) => {
    const updateRatings = await Courses.findByIdAndUpdate(req.body.courseId, {
        courseRatings: req.body.newRatings,
        $push: {
            ratings: req.user._id
        }
    });
    const addInUser = await User.findByIdAndUpdate(req.user._id, {
        $push: {
            ratingsGiven: req.body.courseId
        }
    });


    if (updateRatings && addInUser) {
        res.status(201).json(updateRatings);
    }
});


router.post('/searchcourse', (req, res) => {
    let coursePattern = new RegExp("^" + req.body.query)
    Courses.find({ courseName: { $regex: coursePattern } })
        .then(course => {
            res.status(201).json(course);
        }).catch((e) => {
            console.log(e)
        })
});


router.get('/getUserCourse', reqLogin,async(req, res) => {
    await User.find({ _id: req.user._id })
    .populate("ratingsGiven" ," _id courseName channelName coursePic")
        .then((user) => {
            res.status(201).json(user);
        }).catch((e) => {
            console.log(e)
        })
});


router.get('/getCourse/:id', async(req, res) => {
    await Courses.find({ _id: req.params.id })
    .populate("comments","commentedText commentedBy")
    .then(course => {
        res.status(201).json(course);
    }).catch((e) => {
        console.log(e);
    })
});

router.get('/getCourseByCat/:category', async(req, res) => {
    await Courses.find({ category: req.params.category })
    .populate("comments","commentedText commentedBy")
    .then(course => {
        res.status(201).json({data:course});
    }).catch((e) => {
        console.log(e);
    })
});

router.put('/removeRating/:id', reqLogin,async(req, res) => {
    const data = await Courses.findByIdAndUpdate(req.user._id, {
        $pull: {
            ratedBy: req.user._id
        }
    });

    const removeFromUser = await User.findByIdAndUpdate(req.user._id, {
        $pull: {
            ratingGiven:req.params.id
        }
    })
    res.status(201).json(data, removeFromUser);
});

router.get('/reqCourses',reqLogin,reqAdmin,async(req,res)=>{
    try{
    const courses = await Courses.find({isAccepted:false});
    res.status(201).json({data:courses});
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.put("/acceptCourse/:id",reqLogin,reqAdmin,async(req,res)=>{
    try{
        const accepted = await Courses.findByIdAndUpdate(req.params.id,{
            isAccepted:true
        });
        res.status(201).json({data:accepted}); 
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.put("/rejectCourse/:id",reqLogin,reqAdmin,async(req,res)=>{
    try{
        await Courses.findByIdAndDelete(req.params.id);
        res.status(201).json({success:true,message:"Course Deleted"}); 
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});


router.delete("/deleteCourse/:id",reqLogin,reqAdmin,async(req,res)=>{
    try{
         await Courses.findByIdAndDelete(req.params.id);
        res.status(201).json({data:"Deleted"})
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.get("/getCategory",async(req,res)=>{
    try{
        const category = await Category.find({});
        res.status(201).json({data:category});
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});


router.post("/addCategory",reqLogin,reqAdmin,async(req,res)=>{
    try{
        const {categoryName,categoryPic} = req.body;
        const category = Category({
            categoryName,
            categoryPic
        });

        await category.save().then((data)=>{
            res.status(201).json({data})
        })
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.post("/addComment/:id",reqLogin,async(req,res)=>{
    try{
    const {commentedText}=req.body;
    if(!commentedText){
        return res.status(401).json({error:"Please Add Comment Text"});
    }else{
        const comment =  new Comment({
            commentedText,
            commentedBy:req.user.name,
            commentedCourse:req.params.id
        });
        await comment.save().then((d)=>{
            Courses.findByIdAndUpdate(req.params.id,{
                hasBeenCommented:true,
                $push:{
                    comments:d._id
                }
            }).then(()=>{
                res.status(201).json("Comment Added")
            })
        });
    }
}catch(e){
    res.status(401).json({error:"Error Occured"});
}
});

module.exports = router;
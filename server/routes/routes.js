const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const b = require('bcryptjs');
const User = mongoose.model("User");
require("dotenv").config();
const Courses = mongoose.model('Courses');
const reqLogin = require('../middleware/reqLogin');
const jwt = require('jsonwebtoken');
const Category = require('../models/category');
const Comment = require('../models/comment');
const OTP = require('../models/otp');
const otpgen = require('otp-generator');
const { sendOTP } = require('../utils/mail');

router.get('/', (req, res) => {
    res.send("CourseRiver");
});

router.post("/signup", async(req, res) => {
    console.log(req.body);
    const {email,password,name,image} = req.body;
    if(!email || !password || !name){
        return res.status(401).json({message:"Please Add All The Feilds",success:false})
    }
    try {
        const exist = await User.findOne({ email });
        
        if (exist) {
            return res.json({success:false,message:"User Already Exists"});
        }
        
        else {
            const otp = otpgen.generate(6, {
                digits: true,
                lowerCaseAlphabets: false,
                upperCaseAlphabets: false,
                specialChars: false
            });
            const newOTP = await OTP({
                email,
                otp
            });
            await newOTP.save();
            sendOTP(email, otp);
            b.hash(password, 8)
            .then(async(hashedpassword) => {
            const newUser = User({
                email,
                password:hashedpassword,
                name,
                image
            });
            await newUser.save();
            // const token = jwt.sign({ _id: newUser._id }, process.env.JWT_KEY);
            return res.status(200).json({message:"Otp sent successfully",success:true});
        })
    }
    } catch (e) {
        console.log(e.message);
        res.status(500).json("Error :" + e.message);
    }
});


router.post("/login", async(req, res) => {
    const {email,password} = req.body;
    try {
        const exist = await User.findOne({email});
        console.log(exist);
        if (exist && exist.verified) {
            b.compare(password,exist.password).then((matched)=>{
                if(matched){
                const token = jwt.sign({ _id: exist._id }, process.env.JWT_KEY);
                return res.status(200).json({name:exist.name,
                    image: exist.image, email: exist.email, token,
                verified:true,success:true
                });
                }else{
                    return res.json({message:"Invalid Email or Password",success:false,verified:true})
                }
            });
        }
            if (exist !==null && !exist?.verifed) {
             return res.json({verified:false,success:false,message:"Please Verify your email"});
            }
        else {
            res.json({message:"User Doesnt Exist",success:false,verified:false});
        }
    } catch (e) {
        console.log(e);
    }
});


router.post('/verifyOTP', async (req, res) => {
    const checkotp = await OTP.findOne({ otp: req.body.otp, email:req.body.email });
    console.log(checkotp);
    if (!checkotp) {
        return res.json({message:"Not a Valid OTP",success:false});
    } else {
        await User.findOneAndUpdate({
            email: checkotp.email
        }, { 
            verified: true
        }, {
            new: true
        }).then(async (s) => {
            console.log(s)
            await OTP.findOneAndDelete({ email: checkotp.email });
        }).then(() => {
            res.status(200).json({
                message: "OTP Verified Successfully",
                success:false
            })
        })
    }
});

router.post('/resetPassword', async (req, res) => {
    const checkotp = await OTP.findOne({ otp: req.body.otp, email:req.body.email });
    console.log(checkotp);
    if (!checkotp) {
        return res.status(401).json({message:"Not a Valid OTP",success:false});
    } else {
        const hashedpassword = b.hash(req.body.password,10);
        await User.findOneAndUpdate({
            email: checkotp.email,
            verifed:true
        }, {
            password:hashedpassword
        }, {
            new: true
        }).then(async () => {
            await OTP.findOneAndDelete({ email: checkotp.email });
        }).then(() => {
            res.status(200).json({
                message: "Password Changed Successfully",
                success:true                
            })
        })
    }
});

router.post('/sendforgotpasswordOTP', async (req, res) => {
    const { email } = req.body;
    const user = await User.find({ email });
    if (!user) {
      return res.status(201).json({
        success: false,
        message: "User not found"
    });
    }
    const otp = otpgen.generate(6, {
            digits: true,
            lowerCaseAlphabets: false,
            upperCaseAlphabets: false,
            specialChars: false
        });
    const newOTP = await OTP({
        otp,
        email
    });
    await newOTP.save();
    sendOTP(email, otp);
    res.status(201).json({
        success: true,
        message: "Forgot Password OTP Sent"
    });
});






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
        .catch((e) => {
            console.log(e);
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

// {
//     "courseName":"Flutter Social App",
//     "courseDescription":"Its a Flutter course for making a social app using flutter and firebase as a backend",
//     "channelName":"Abhishvek",
//     "courseUrl":"https://www.youtube.com/playlist?list=PLRT5VDuA0QGW4VTls7y-5-EJd8rMdIegW",
//     "isHighestRated":true,
//     "isRecentlyAdded":true,
//     "isTrendingCourse":"true",
//     "coursePic":"http://res.cloudinary.com/harshit111/image/upload/v1626688025/rxmyz6dyjpusgs0d9wvn.jpg",
//     "catgeory":"Flutter",
//     "courseRatings":"3.5",
//     "coursePublishedOn":"2021/01/04"
// }


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

    if (addInUser) {
        console.log("Added in User");
    }

    if (updateRatings) {
        res.status(201).json(updateRatings);
    }
});

router.post('/adminData', (req, res) => {

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
    const ress = await Courses.findByIdAndUpdate(req.user._id, {
        $pull: {
            ratedBy: req.user._id
        }
    });

    const removeFromUser = await User.findByIdAndUpdate(req.user._id, {
        $pull: {
            ratingGiven:req.params.id
        }
    })
    res.status(201).json(ress, removeFromUser);
});

router.get('/reqCourses',async(req,res)=>{
    try{
    const courses = await Courses.find({isAccepted:false});
    res.status(201).json({data:courses});
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.put("/acceptCourse/:id",reqLogin,async(req,res)=>{
    try{
        const accepted = await Courses.findByIdAndUpdate(req.params.id,{
            isAccepted:true
        });
        res.status(201).json({data:accepted}); 
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.put("/rejectCourse/:id",reqLogin,async(req,res)=>{
    try{
        const accepted = await Courses.findByIdAndDelete(req.params.id);
        res.status(201).json({success:true,message:"Course Deleted"}); 
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});


router.delete("/deleteCourse/:id",async(req,res)=>{
    try{
        const deleted = await Courses.findByIdAndDelete(req.params.id);
        console.log(deleted);
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


router.post("/addCategory",async(req,res)=>{
    try{
        const {categoryName,categoryPic} = req.body;
        const category = Category({
            categoryName,
            categoryPic
        });

        await category.save().then((s)=>{
            res.status(201).json({data:s})
        })
    }catch(e){
        res.status(401).json({error:"Error Occured"});
    }
});

router.post("/addComment/:id",reqLogin,async(req,res)=>{
    try{
    const {commentedText}=req.body;
    console.log(req.body)
    if(!commentedText){
        return res.status(401).json({error:"Please Add Comment Text"});
    }else{
        const comment =  new Comment({
            commentedText,
            commentedBy:req.user.name,
            commentedCourse:req.params.id
        });
        await comment.save().then((d)=>{
            console.log(d)
            Courses.findByIdAndUpdate(req.params.id,{
                hasBeenCommented:true,
                $push:{
                    comments:d._id
                }
            }).then((p)=>{
                res.status(201).json("Comment Added")
            })
        });
    }
}catch(e){
    res.status(401).json({error:"Error Occured"});
}
});

module.exports = router;
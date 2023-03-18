const router = require("express").Router();
const bcrypt = require('bcryptjs');

require("dotenv").config();

const jwt = require('jsonwebtoken');

const User = require("../models/user");
const OTP = require('../models/otp');

const otpgen = require('otp-generator');
const { sendOTP } = require('../utils/mail');


router.post("/signup", async(req, res) => {
    const {email,password,name,image} = req.body;
    if(!email || !password || !name){
        return res.status(401).json({message:"Please Add All The Feilds",success:false})
    }
    try {
        const exist = await User.findOne({ email });
        
        if (exist) {
            return res.status(400).json({success:false,message:"User Already Exists"});
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
            bcrypt.hash(password, 8)
            .then(async(hashedpassword) => {
            const newUser = User({
                email,
                password:hashedpassword,
                name,
                image
            });
            await newUser.save();
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
        if (exist && exist.verified) {
            bcrypt.compare(password,exist.password).then((matched)=>{
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






module.exports = router;
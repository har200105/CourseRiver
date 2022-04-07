const nodemailer = require('nodemailer');
const transport = nodemailer.createTransport({
    service: "Gmail",
    auth: {
        user: process.env.USER_EMAIL,
        pass: process.env.USER_PASSWORD
    }
});


exports.sendOTP = async (email, otp) => {
    await transport.sendMail({
        from: process.env.USER_EMAIL,
        to: email,
        subject: "Verify Your Account",
        html: `<h3>
        YOUR OTP IS ${otp} for verifying your account at Course River.
        </h3>`
    }).then((s) => {
        console.log("Verification Email Sent")
    })
}

exports.sendForgotPasswordOTP = async (email, otp) => {
    await transport.sendMail({
        from: process.env.USER_EMAIL,
        to: email,
        subject: "Forgot Password",
        html: `<h3>
        YOUR OTP IS ${otp} for resetting your account at Course River.
        </h3>`
    }).then((s) => {
        console.log("FORGOT PASSWORD Email Sent")
    })
}





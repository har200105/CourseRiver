module.exports = (req, res, next) => {
  const { user } = req;
    if (!user.isAdmin) {
        return res.status(401).json({ error: "You are not authorized to perform this action" });
    }
  next();
};
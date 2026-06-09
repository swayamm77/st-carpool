const express = require("express");
const router = express.Router();

const {
  createUser,
  getUsers,
  getUserByEmail,
} = require("../controllers/userController");

router.post("/", createUser);
router.get("/", getUsers);
router.get("/email/:email", getUserByEmail);

module.exports = router;
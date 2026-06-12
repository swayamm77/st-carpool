const express = require("express");
const router = express.Router();

const {
  createUser,
  getUsers,
  getUserByEmail,
  updateVehicle,
} = require("../controllers/userController");

router.post("/", createUser);
router.get("/", getUsers);
router.get("/email/:email", getUserByEmail);
router.patch(
  "/:id/vehicle",
  updateVehicle
);

module.exports = router;
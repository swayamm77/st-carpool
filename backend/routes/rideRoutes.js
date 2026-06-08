const express = require("express");
const router = express.Router();

const {
  createRide,
  getRides,
} = require("../controllers/rideController");

router.post("/", createRide);
router.get("/", getRides);

module.exports = router;
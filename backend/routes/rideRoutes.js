const express = require("express");
const router = express.Router();

const {
  createRide,
  getRides,
  deleteRide,
} = require("../controllers/rideController");

router.post("/", createRide);
router.get("/", getRides);
router.delete("/:id", deleteRide);

module.exports = router;
const express = require("express");
const router = express.Router();

const {
  createRide,
  getRides,
  deleteRide,
  completeRide,
} = require("../controllers/rideController");

router.post("/", createRide);
router.get("/", getRides);
router.delete("/:id", deleteRide);
router.patch(
  "/:id/complete",
  completeRide
);

module.exports = router;
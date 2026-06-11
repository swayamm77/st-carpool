const express = require("express");
const router = express.Router();

const {
  createRequest,
  getRequests,
  updateRequestStatus,
  checkRequestStatus,
} = require("../controllers/requestController");

router.post("/", createRequest);
router.get("/", getRequests);
router.get(
  "/check/:rideId/:passengerId",
  checkRequestStatus
);
router.patch("/:id", updateRequestStatus);

module.exports = router;
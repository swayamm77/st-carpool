const express = require("express");

const {
  createAddress,
  getAddresses,
} = require(
  "../controllers/addressController"
);

const router = express.Router();

router.post(
  "/",
  createAddress
);

router.get(
  "/:userId",
  getAddresses
);

module.exports = router;
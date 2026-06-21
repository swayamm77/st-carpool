const express = require("express");

const {
  createAddress,
  getAddresses,
  deleteAddress,
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

router.delete("/:id", deleteAddress);

module.exports = router;
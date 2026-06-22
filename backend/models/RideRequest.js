const mongoose = require("mongoose");

const rideRequestSchema = new mongoose.Schema(
  {
    rideId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Ride",
      required: true,
    },

    passengerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    pickupAddress: {
  type: String,
},

pickupLat: {
  type: Number,
},

pickupLng: {
  type: Number,
},

    status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
    
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("RideRequest", rideRequestSchema);
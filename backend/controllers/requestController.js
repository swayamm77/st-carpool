const RideRequest = require("../models/RideRequest");
const Ride = require("../models/Ride");

const createRequest = async (req, res) => {
  try {
    const ride = await Ride.findById(req.body.rideId);

    if (!ride) {
      return res.status(404).json({
        message: "Ride not found",
      });
    }

    // Prevent requesting own ride
    if (
      ride.driverId.toString() ===
      req.body.passengerId
    ) {
      return res.status(400).json({
        message: "You cannot request your own ride",
      });
    }

    // Prevent duplicate requests
    const existingRequest =
      await RideRequest.findOne({
        rideId: req.body.rideId,
        passengerId: req.body.passengerId,
      });

    if (existingRequest) {
      return res.status(400).json({
        message:
          "You have already requested this ride",
      });
    }

    const request = await RideRequest.create(
      req.body
    );

    res.status(201).json(request);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
};

const getRequests = async (req, res) => {
  try {
    const requests = await RideRequest.find()
      .populate("rideId")
      .populate("passengerId");

    res.status(200).json(requests);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

const updateRequestStatus = async (req, res) => {
  try {
    const { status } = req.body;
    
    const validStatuses = ["approved", "rejected"];

if (!validStatuses.includes(status)) {
  return res.status(400).json({
    message: "Invalid status",
  });
}

    const request = await RideRequest.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        message: "Request not found",
      });
    }

    if (request.status !== "pending") {
        return res.status(400).json({
            message: "Request has already been processed",
         });
    }

    request.status = status;

    if (status === "approved") {
      const ride = await Ride.findById(request.rideId);

      if (!ride) {
        return res.status(404).json({
          message: "Ride not found",
        });
      }

      if (ride.availableSeats <= 0) {
        return res.status(400).json({
          message: "No seats available",
        });
      }

      ride.availableSeats -= 1;

      if (ride.availableSeats === 0) {
        ride.status = "full";
      }

      await ride.save();
    }

    await request.save();

    res.status(200).json(request);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

const checkRequestStatus = async (req, res) => {
  try {
    const request = await RideRequest.findOne({
      rideId: req.params.rideId,
      passengerId: req.params.passengerId,
    });

    if (!request) {
      return res.status(200).json({
        status: null,
      });
    }

    res.status(200).json({
      status: request.status,
    });
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

module.exports = {
  createRequest,
  getRequests,
  updateRequestStatus,
  checkRequestStatus,
};
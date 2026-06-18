const Ride = require("../models/Ride");
const RideRequest = require("../models/RideRequest");

const createRide = async (req, res) => {
  try {
    const ride = await Ride.create(req.body);

    res.status(201).json(ride);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
};

const getRides = async (req, res) => {
  console.log("GET RIDES HIT");
  try {
    const rides = await Ride.find();

    const now = new Date();

    for (const ride of rides) {

const oneHourBeforeDeparture =
  new Date(
    ride.departureTime.getTime() -
    5 * 60 * 1000
  );


  if (
    new Date() >= oneHourBeforeDeparture &&
    ride.status !== "completed" &&
    ride.status !== "expired"
  ) {
    const approvedRequests =
      await RideRequest.countDocuments({
        rideId: ride._id,
        status: "approved",
      });

    if (approvedRequests === 0) {
      console.log(
  `Ride expired: ${ride.source}`
);
      ride.status = "expired";
      await ride.save();
    }
  }
}

    const updatedRides =
      await Ride.find().populate(
        "driverId"
      );

    res.status(200).json(
      updatedRides
    );
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};


const deleteRide = async (req, res) => {
  try {
    const ride = await Ride.findById(req.params.id);

    if (!ride) {
      return res.status(404).json({
        message: "Ride not found",
      });
    }

    await RideRequest.deleteMany({
      rideId: req.params.id,
    });

    await Ride.findByIdAndDelete(
      req.params.id
    );

    res.status(200).json({
      message: "Ride deleted successfully",
    });
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

const completeRide = async (req, res) => {
  try {
    const ride = await Ride.findById(
      req.params.id
    );

    if (!ride) {
      return res.status(404).json({
        message: "Ride not found",
      });
    }

    ride.status = "completed";

    await ride.save();

    res.status(200).json(ride);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

module.exports = {
  createRide,
  getRides,
  deleteRide,
  completeRide,
};
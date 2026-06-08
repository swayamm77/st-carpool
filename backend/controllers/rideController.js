const Ride = require("../models/Ride");

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
  try {
    const rides = await Ride.find().populate("driverId");

    res.status(200).json(rides);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

module.exports = {
  createRide,
  getRides,
};
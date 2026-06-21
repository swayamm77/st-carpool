const Address = require("../models/Address");

const createAddress = async (
  req,
  res
) => {
  try {
    const address =
      await Address.create(req.body);

    res.status(201).json(address);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
};

const getAddresses = async (
  req,
  res
) => {
  try {
    const addresses =
      await Address.find({
        userId: req.params.userId,
      });

    res.status(200).json(
      addresses
    );
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

const deleteAddress = async (
  req,
  res
) => {
  try {
    await Address.findByIdAndDelete(
      req.params.id
    );

    res.status(200).json({
      message:
          "Address deleted",
    });
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

module.exports = {
  createAddress,
  getAddresses,
  deleteAddress,
};
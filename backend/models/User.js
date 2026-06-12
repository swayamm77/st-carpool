const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },

    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      validate: {
        validator: function (email) {
          return email.endsWith("@st.com");
        },
        message: "Only ST email addresses are allowed",
      },
    },

    department: {
      type: String,
      default: "",
    },

    phoneNumber: {
      type: String,
      default: "",
    },

    vehicleRegistered: {
  type: Boolean,
  default: false,
},

vehicleNumber: {
  type: String,
  default: "",
},

vehicleModel: {
  type: String,
  default: "",
},

vehicleSeats: {
  type: Number,
  default: 0,
},

    isDriver: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("User", userSchema);
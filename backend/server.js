const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const rideRoutes = require("./routes/rideRoutes");
const requestRoutes = require("./routes/requestRoutes");

dotenv.config();

connectDB();

const app = express();

app.use(express.json());
app.use("/api/users", userRoutes);
app.use("/api/rides", rideRoutes);
app.use("/api/requests", requestRoutes);

app.get("/", (req, res) => {
  res.send("ST Carpool Backend Running");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
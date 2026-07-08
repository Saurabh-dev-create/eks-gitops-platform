const express = require("express");

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
    res.json({
        service: "API Service",
        status: "Running",
        environment: process.env.NODE_ENV || "dev"
    });
});

app.get("/health", (req, res) => {
    res.status(200).send("OK");
});

app.listen(PORT, () => {
    console.log(`API listening on ${PORT}`);
});

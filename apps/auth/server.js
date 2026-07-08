const express = require("express");

const app = express();
const PORT = 3001;

app.get("/", (req, res) => {
    res.json({
        service: "Auth Service",
        status: "Running"
    });
});

app.get("/health", (req, res) => {
    res.status(200).send("OK");
});

app.listen(PORT, () => {
    console.log(`Auth service listening on ${PORT}`);
});

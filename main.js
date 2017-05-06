var PEG = require("./arithmetics.js");
var input = process.argv[2] || "a < 5";
console.log(`Processing <${input}>`);
var r = PEG.parse(input);
console.log(r);

export const formattedAmount = (amount) => {
  var roundedNumber = Number((amount).toFixed(2)).toString();
  var parts = roundedNumber.split(".");

  if (parts.length == 1) {
    parts.push("00");
  }

  while (parts[1].length < 2) {
    parts[1] = parts[1] + "0";
  }
  return parts.join(".")
}

export const PETAL = "Manifest-Gold";
export const INVARIANT = "MANIFEST_STATIONARY";
export function verify(input) {
  if (!input || typeof input !== "object") {
    return {
      pass: false,
      stationary: false,
      signal: "manifest-gold:INVALID_INPUT",
      reason: "input must be an object"
    };
  }
  const stationary =
    input.repo === "Riverbraid-Manifest-Gold" &&
    input.petal === "Manifest-Gold" &&
    input.ring === 1 &&
    input.invariant === "MANIFEST_STATIONARY";
  return {
    pass: true,
    stationary,
    signal: stationary ? "manifest-gold:STATIONARY" : "manifest-gold:DRIFT",
    reason: stationary
      ? "Stationary fields match declared petal identity"
      : "One or more stationary fields drift from declaration"
  };
}

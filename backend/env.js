import dotenv from "dotenv";

function getEnv(name, required = true) {
  dotenv.config({ override: true });
  
  const value = process.env[name];

  if (required && (value === undefined || value === "")) {
    throw new Error(`❌ Environment variable ${name} is missing or empty.`);
  }

  return value;
}

export const MONGO_CONNECTION_STRING = getEnv("MONGO_CONNECTION_STRING");
export const JWT_SECRET = getEnv("JWT_SECRET");
export const JWT_REFRESH_SECRET = getEnv("JWT_REFRESH_SECRET");
export const PORT = getEnv("PORT", false) || 3000;
import swaggerJSDoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Desmanche Connect API",
      version: "1.0.0",
      description: "Documentação da API Desmanche Connect",
    },
    servers: [
      {
        url: "http://localhost:3000", // ajuste conforme ambiente
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ["./routes/*.js"], 
};

const swaggerSpec = swaggerJSDoc(options);

export function setupSwagger(app) {
  app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));
}

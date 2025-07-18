import { checkSchema } from "express-validator";

const registerUserValidationSchema = checkSchema({
  name: {
    in: ["body"],
    isString: true,
    notEmpty: true,
    errorMessage: "O nome é obrigatório e deve ser uma string",
  },
  username: {
    in: ["body"],
    isLength: {
      options: { min: 6 },
      errorMessage: "A username deve conter pelo menos 3 caracteres",
    },
    notEmpty: true,
    errorMessage: "O username é obrigatório e deve ser válido",
  },
  password: {
    in: ["body"],
    isString: true,
    isLength: {
      options: { min: 6 },
      errorMessage: "A senha deve conter pelo menos 6 caracteres",
    },
    notEmpty: true,
    errorMessage: "A senha é obrigatória",
  },
});

const loginUserValidationSchema = checkSchema({
  username: {
    in: ["body"],
    notEmpty: true,
    errorMessage: "O username é obrigatório e deve ser válido",
  },
  password: {
    in: ["body"],
    isString: true,
    notEmpty: true,
    errorMessage: "A senha é obrigatória",
  },
});

export default { registerUserValidationSchema, loginUserValidationSchema };

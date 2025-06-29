import { checkSchema } from "express-validator";

const createPostValidationSchema = checkSchema({
  data: {
    in: ["body"],
    custom: {
      options: (value, { req }) => {
        let parsed;
        try {
          parsed = JSON.parse(value);
        } catch (err) {
          throw new Error("O campo 'data' deve ser um JSON válido");
        }

        // Validação de título
        if (!parsed.title || typeof parsed.title !== "string" || parsed.title.trim() === "") {
          throw new Error("O título é obrigatório e deve ser uma string");
        }

        // Validação de categoria
        if (!parsed.category || typeof parsed.category !== "string" || parsed.category.trim() === "") {
          throw new Error("A categoria é obrigatória e deve ser uma string");
        }

        // Validação de descrição
        if (!parsed.description || typeof parsed.description !== "string" || parsed.description.trim() === "") {
          throw new Error("A descrição é obrigatória e deve ser uma string");
        }

        // Validação de preço (opcional: se enviado, deve ser número)
        if (parsed.price && isNaN(Number(parsed.price))) {
          throw new Error("O preço deve ser um número válido");
        }

        // Validação de coverImage (opcional)
        if (parsed.coverImage && isNaN(Number(parsed.coverImage))) {
          throw new Error("O índice da imagem de capa deve ser um número");
        }

        // Validação de ativo
        if (typeof parsed.active !== "boolean" && parsed.active !== "true" && parsed.active !== "false") {
          throw new Error("O campo 'active' deve ser um booleano");
        }

        return true;
      },
    },
  },
});
const deletePostValidationSchema = checkSchema({
  id: {
    in: ["params"],
    isMongoId: true,
    notEmpty: true,
    errorMessage: "ID inválido",
  },
});

export default {
  createPostValidationSchema,
  deletePostValidationSchema,
};

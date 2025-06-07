import { checkSchema } from 'express-validator';

export const createPostValidationSchema = checkSchema({
    title: {
        in: ['body'],
        isString: true,
        notEmpty: true,
        errorMessage: 'O título deve ser uma string',
    },
    category: {
        in: ['body'],
        isString: true,
        notEmpty: true,
        errorMessage: 'A categoria deve ser uma string',
    },
    description: {
        in: ['body'],
        isString: true,
        notEmpty: true,
        errorMessage: 'A descrição deve ser uma string',
    },
});

export const deletePostValidationSchema = checkSchema({
    id: {
        in: ['params'],
        isMongoId: true,
        notEmpty: true,
        errorMessage: 'ID inválido',
    }
})

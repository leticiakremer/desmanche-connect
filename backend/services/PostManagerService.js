import axios from "axios";

const FACEBOOK_PAGE_ID = process.env.FACEBOOK_PAGE_ID;
const FACEBOOK_ACCESS_TOKEN = process.env.FACEBOOK_ACCESS_TOKEN;

export class PostPublisherService {
  static async publishToFacebook(post) {
    if (!FACEBOOK_PAGE_ID || !FACEBOOK_ACCESS_TOKEN) {
      console.warn("Facebook Page ID ou Access Token não configurados");
      return;
    }

    const message = `${post.title}\n\n${post.description}`;

    try {
      await axios.post(
        `https://graph.facebook.com/${FACEBOOK_PAGE_ID}/feed`,
        {
          message,
          link: post.coverImage, // opcional
        },
        {
          params: {
            access_token: FACEBOOK_ACCESS_TOKEN,
          },
        }
      );
      console.log("Post publicado com sucesso no Facebook");
    } catch (error) {
      console.error(
        "Erro ao publicar no Facebook:",
        error.response?.data || error.message
      );
    }
  }
}

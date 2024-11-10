
import Foundation


struct GetProfile:Codable{
    let articles: [Article]
      let status: String
  }

  // MARK: - Article
  struct Article: Codable {
      let id: Int
      let title: String
      let createdAt: String?
      let bodyHTML: String
      let blogID: Int
      let author: Author
      let userID: Int
      let publishedAt, updatedAt: String?
      let summaryHTML, templateSuffix, handle, tags: String
      let adminGraphqlAPIID: String
      let image: Image

      enum CodingKeys: String, CodingKey {
          case id, title
          case createdAt = "created_at"
          case bodyHTML = "body_html"
          case blogID = "blog_id"
          case author
          case userID = "user_id"
          case publishedAt = "published_at"
          case updatedAt = "updated_at"
          case summaryHTML = "summary_html"
          case templateSuffix = "template_suffix"
          case handle, tags
          case adminGraphqlAPIID = "admin_graphql_api_id"
          case image
      }
  }

  enum Author: String, Codable {
      case conversionsDMCC = "Conversions DMCC"
      case hanayenFashion = "Hanayen Fashion"
  }

  // MARK: - Image
  struct Image: Codable {
      let createdAtr: String
      let alt: Alt
      let width, height: Int
      let src: String

      enum CodingKeys: String, CodingKey {
          case createdAtr = "created_at"
          case alt, width, height, src
      }
  }

  enum Alt: String, Codable {
      case abayaIsSymbolOfModestElegance = " abaya is Symbol of Modest Elegance:"
      case abayaTrendsFashionInDubai = "abaya trends fashion in dubai"
      case abayasMustHaves = "abayas - must-haves"
      case empty = ""
  }




struct ApiError: Error {
    let errorCode: Int
    let errorMsg: String
}

struct SuccessModel: Codable {
    let status: Int
    let message, time: String
}

import Foundation
import Merchant

struct HTTPClient {
    @GET
    var getGroceries: [Grocery]
    
    @DELETE("/{id}")
    var delete: StatusReponse<Bool>
    
    @POST("/available", body: Bool.self)
    var toggleAvailability: StatusReponse<Bool>
    
    @PUT(body: Grocery.self)
    var addGroceryItem: StatusReponse<Grocery>
}

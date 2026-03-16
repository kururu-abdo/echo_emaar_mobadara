class ApiConstants {
  static const String odooBaseUrl = 'http://192.168.100.221:8017';
  static const String odooDatabase = 'your_database_name';
  //Endpoints
      static const String loginEndpoint = '/api/auth';
      static const String registerEndpoint = '/api/register';
      static const String productsEndpoint ="/api/products/";
      static const String mostSoldProductsEndpoint ="/api/products/most-sold";
      static const String categoriesEndpoint ="/mobadra/categories";
      static const String cartEndpiint ="/api/cart/";
      static const String addToCartEndpiint ="/api/cart/add/multiple";
      static const String updateCartEndpiint ="/api/cart/update";
      static const String updateAddressEndpoint ="/api/addresses/update";
      static const String getAddressEnpoint = "/api/addresses/current";
     static const String getCountriesEnpoint = "/api/countries/";
     static const String getStatesEndpoint ="/api/countries/"; // <int:country_id>/states
    static const String placeOrderEndpoint = "/api/cart/confirm";
    static const String allOrdersEndpoint ="/api/partner/all_orders";
    static const String orderDetailsEndpoint ="/api/orders/";
    static const String invoicesEndpoint="/api/partner/all_invoices";
    




  // Odoo Models
  static const String productModel = 'product.product';
  static const String categoryModel = 'product.category';
  static const String partnerModel = 'res.partner';
  static const String saleOrderModel = 'sale.order';
  static const String saleOrderLineModel = 'sale.order.line';
  
  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
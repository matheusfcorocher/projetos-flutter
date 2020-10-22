enum OrderBy {DATE, PRICE}

//bit flag
const VENDOR_TYPE_PARTICULAR = 1 << 0;// representa o deslocamento 0 do 1 => 0001
const VENDOR_TYPE_PROFESSIONAL = 1 << 1;// representa o deslocamento 1 do 1 => 0010

//VENDOR_TYPE_PARTICULAR | VENDOR_TYPE_PROFESSIONAL => representa ou logico => 0011

class Filter {

  String search;
  OrderBy orderBy;
  int minPrice;
  int maxPrice;
  int vendorType;

  Filter({
    this.search,
    this.orderBy = OrderBy.DATE,
    this.minPrice,
    this.maxPrice,
    this.vendorType = VENDOR_TYPE_PARTICULAR | VENDOR_TYPE_PROFESSIONAL
  });

}
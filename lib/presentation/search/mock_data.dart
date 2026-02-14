class RideData {
  final String startTime;
  final String endTime;
  final String duration;
  final String startCity;
  final String startAddress;
  final String endCity;
  final String endAddress;
  final String? intermediateCity; // e.g. Yamuna Nagar
  final double? price;
  final bool isFull;
  final String driverName;
  final double rating;
  final int ratingCount;
  final bool isVehicleElectric;
  final bool instantBook;
  final bool isVerifiedProfile;
  final String? cancellationTrend; // e.g. "Sometimes cancels rides"

  RideData({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.startCity,
    this.startAddress = "Address not specified",
    required this.endCity,
    this.endAddress = "Address not specified",
    this.intermediateCity,
    this.price,
    this.isFull = false,
    required this.driverName,
    required this.rating,
    this.ratingCount = 0,
    this.isVehicleElectric = false,
    this.instantBook = true,
    this.isVerifiedProfile = false,
    this.cancellationTrend,
  });
}

final List<RideData> mockRides = [
  RideData(
    startTime: "14:50",
    endTime: "16:50",
    duration: "2h00",
    startCity: "Faridabad",
    startAddress:
        "Shahid Bhagat Singh Marg, AC Nagar, New Industrial Township, Haryana",
    endCity: "Panipat",
    endAddress: "33/16, Ram Nagar, Tehsil Camp, Haryana",
    intermediateCity: "Yamuna Nagar",
    price: 430.00,
    driverName: "Himanshu",
    rating: 4.33,
    ratingCount: 15,
    isVerifiedProfile: true,
    cancellationTrend: "Sometimes cancels rides",
  ),
  RideData(
    startTime: "15:00",
    endTime: "16:50",
    duration: "1h50",
    startCity: "Noida",
    startAddress: "Sector 18, Noida, Uttar Pradesh",
    endCity: "Panipat",
    endAddress: "Bus Stand, Panipat, Haryana",
    isFull: true,
    driverName: "Sandeep",
    rating: 4.8,
    ratingCount: 42,
  ),
  RideData(
    startTime: "15:00",
    endTime: "17:20",
    duration: "2h20",
    startCity: "Bajidpur",
    startAddress: "Bajidpur Village, Delhi",
    endCity: "Panipat",
    endAddress: "Model Town, Panipat, Haryana",
    price: 280.00,
    driverName: "Shubham",
    rating: 4.8,
    ratingCount: 8,
    instantBook: true,
  ),
  RideData(
    startTime: "15:00",
    endTime: "17:30",
    duration: "2h30",
    startCity: "Greater Noida",
    startAddress: "Pari Chowk, Greater Noida, UP",
    endCity: "Panipat",
    endAddress: "GT Road, Panipat, Haryana",
    price: 300.00,
    driverName: "Ravi",
    rating: 4.5,
    ratingCount: 20,
    intermediateCity: "Murthal",
  ),
];
